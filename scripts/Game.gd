extends Node2D

# Constants

const TOTAL_SECONDS = 60.0
const TOTAL_ORBS_FOR_VICTORY = 100.0
const NUMBER_MAPS = 10
const EVO_GENERATIONS_PER_MAPS = 10

const MapData = preload("map_data.gd")
const MapEvaluator = preload("map_evaluator.gd")
const EvolutionManager = preload("evolution_manager.gd")
const utils = preload("utils.gd")
const MapSpawner = preload("map_spawner.gd")

const Orb = preload("../Orb.tscn")
const LadderSound = preload("res://audio/Ladder.wav")

onready var global_vars = get_node("/root/GlobalVariables")
onready var tile_map = get_node("TileMap")

var evolution_manager
var map_evaluator
var maps_list

var map_index

var time_count
var collected_orbs

func _ready():
	
	# Initial setup
	
	randomize()
	maps_list = []
	evolution_manager = EvolutionManager.new()
	map_evaluator = MapEvaluator.new()
	tile_map.get_node("Fitness").text = ""
	time_count = TOTAL_SECONDS
	collected_orbs = 0
	
	# Generate all maps for this run
	
	for i in range(NUMBER_MAPS):
		evolution_manager.initiate_population()
		
		for j in range(EVO_GENERATIONS_PER_MAPS):
			evolution_manager.update_generation()
		
		# Print fitness

		maps_list.append(evolution_manager.map_array[0])
#		print(str(map_evaluator.get_fitness(evolution_manager.map_array[0])))
	
	map_index = -1
	next_map()

func _process(delta):
	time_count -= delta
	#<-- show
	if time_count <= 0.0:
		finish_game(false)
		set_process(false)

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_SPACE:
			next_map()
	pass

func render_map(map):
	# Get a matrix representation of the map.
	var matrix = MapSpawner.get_map_matrix_border(map)
	# Assign matrix to tile map.
	for i in range(map.SIZE.x+2):
		for j in range(map.SIZE.y+2):
			tile_map.set_cellv(Vector2(i,j), matrix[i][j])
	# Spawn props
	spawn_orbs(map)
	# Spawn player
	spawn_player(map)

func spawn_orbs(map):
	for orb_location in map.orb_locations:
		var new_orb = Orb.instance()
		new_orb.position = convert_matrix_to_real_space(orb_location)
		$OrbParent.add_child(new_orb)

func spawn_player(map):
	$Player.position = convert_matrix_to_real_space(map.entrance)

func next_map():
	map_index += 1
	
	$SoundFXPlayer.stream = LadderSound
	$SoundFXPlayer.play()
	
	if map_index >= NUMBER_MAPS:
		finish_game(true)
		return
	
	# Clear remaining orbs
	
	for orb in $OrbParent.get_children(): 
		$OrbParent.remove_child(orb)
	
	# Generate props and render next map
	
	var next_map = maps_list[map_index]
	next_map.generate_orbs()
	render_map(next_map)


func convert_matrix_to_real_space(matrix_pos):
	var real_pos = tile_map.position
	real_pos += Vector2(matrix_pos.x*utils.CELL_SIZE, matrix_pos.y*utils.CELL_SIZE)
	# Add border cells
	real_pos += Vector2(utils.CELL_SIZE, utils.CELL_SIZE) 
	# Go to center of cell
	real_pos += Vector2(utils.CELL_SIZE/2, utils.CELL_SIZE/2)
	return real_pos

func finish_game(reached_core):
	global_vars.reached_core = reached_core
	global_vars.collected_orbs = collected_orbs
	global_vars.remaining_time = time_count
	get_tree().change_scene("res://Results.tscn")
