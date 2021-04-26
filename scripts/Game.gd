extends Node2D

# Constants

const NUMBER_MAPS = 10
const EVO_GENERATIONS_PER_MAPS = 10

const MapData = preload("map_data.gd")
const MapEvaluator = preload("map_evaluator.gd")
const EvolutionManager = preload("evolution_manager.gd")
const utils = preload("utils.gd")
const MapSpawner = preload("map_spawner.gd")

const Orb = preload("../Orb.tscn")

onready var tile_map = get_node("TileMap")

var evolution_manager
var map_evaluator
var maps_list

var map_index

func _ready():
	
	# Initial setup
	
	randomize()
	maps_list = []
	evolution_manager = EvolutionManager.new()
	map_evaluator = MapEvaluator.new()
	tile_map.get_node("Fitness").text = ""
	
	# Generate all maps for this run
	
	for i in range(NUMBER_MAPS):
		evolution_manager.initiate_population()
		
		for j in range(EVO_GENERATIONS_PER_MAPS):
			evolution_manager.update_generation()
		
		# Print fitness

		maps_list.append(evolution_manager.map_array[0])
		print(str(map_evaluator.get_fitness(evolution_manager.map_array[0])))
	
	map_index = -1
	next_map()

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_SPACE:
			next_map()

func render_map(map):
	# Get a matrix representation of the map.
	var matrix = MapSpawner.get_map_matrix_border(map)
	# Assign matrix to tile map.
	for i in range(map.SIZE.x+2):
		for j in range(map.SIZE.y+2):
			tile_map.set_cellv(Vector2(i,j), matrix[i][j])
	# Spawn props
	spawn_orbs(map)

func spawn_orbs(map):
	for orb_location in map.orb_locations:
		var new_orb = Orb.instance()
		print(orb_location)
		new_orb.position = Vector2(utils.CELL_SIZE/2 + orb_location.x*utils.CELL_SIZE, utils.CELL_SIZE/2 + orb_location.y*utils.CELL_SIZE)
		new_orb.position += Vector2(utils.CELL_SIZE, utils.CELL_SIZE) # Add border cells
		$OrbParent.add_child(new_orb)

func next_map():
	map_index += 1
	
	# Clear remaining orbs
	
	for orb in $OrbParent.get_children(): 
		$OrbParent.remove_child(orb)
	
	# Generate props and render next map
	
	var next_map = maps_list[map_index]
	next_map.generate_orbs()
	render_map(next_map)
