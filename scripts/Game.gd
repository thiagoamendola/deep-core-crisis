extends Node2D

# Constants

const NUMBER_MAPS = 10
const EVO_GENERATIONS_PER_MAPS = 10

const MapData = preload("map_data.gd")
const MapEvaluator = preload("map_evaluator.gd")
const EvolutionManager = preload("evolution_manager.gd")

const MapSpawner = preload("map_spawner.gd")

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
		
		maps_list.append(evolution_manager.map_array[0])
		print(str(map_evaluator.get_fitness(evolution_manager.map_array[0])))
	
	map_index = 0
	render_map(maps_list[map_index])

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_SPACE:
			next_map()

func render_map(map):
	# Get a matrix representation of the map.
	var matrix = MapSpawner.get_map_matrix_border(map)
	# Assign matrix to map view.
	for i in range(map.SIZE.x+2):
		for j in range(map.SIZE.y+2):
			tile_map.set_cellv(Vector2(i,j), matrix[i][j])

func next_map():
	map_index += 1
	render_map(maps_list[map_index])
