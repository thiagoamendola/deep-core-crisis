extends Node

# Imports

const utils = preload("utils.gd")

# Constants

const SIZE = Vector2(24,16)
const ROOM_SIZE_MEAN = 6
const ROOM_SIZE_DEVIATION = 1
const NUMBER_ROOMS_MEAN = 5
const NUMBER_ROOMS_DEVIATION = 2
const NUMBER_CORRIDORS_MEAN = 7
const NUMBER_CORRIDORS_DEVIATION = 3

const ORBS_PER_LEVEL = 14

# Structs

class Room:
	var init_pos
	var size

class Corridor:
	var points


var room_list
var corridor_list
var entrance
var exit

var orb_locations

func _init():
	room_list = []
	corridor_list = []

# Creation

func create_room(init_pos, size):
	var room = Room.new()
	room.init_pos = init_pos
	room.size = size
	room_list.append(room)

func create_corridor(points):
	var corridor = Corridor.new()
	corridor.points = points
	corridor_list.append(corridor)

# Random creation

func create_random_map():
	var num_rooms = utils.normal_limits(NUMBER_ROOMS_MEAN, NUMBER_ROOMS_DEVIATION, 3, NUMBER_ROOMS_MEAN+2*NUMBER_ROOMS_DEVIATION)
	var num_corridors = utils.normal_limits(NUMBER_CORRIDORS_MEAN, NUMBER_CORRIDORS_DEVIATION, num_rooms-1, NUMBER_CORRIDORS_MEAN+2*NUMBER_CORRIDORS_DEVIATION)
	for i in range(num_rooms):
		create_random_room()
	for i in range(num_corridors):
		create_random_corridor()
	create_random_entrance_exit()

func create_random_room():
	var room_size = Vector2(utils.normal_limits(ROOM_SIZE_MEAN, ROOM_SIZE_DEVIATION, 2, SIZE.x), utils.normal_limits(ROOM_SIZE_MEAN, ROOM_SIZE_DEVIATION, 2, SIZE.y))
	var room_pos = Vector2(int(rand_range(0, SIZE.x-room_size.x)), int(rand_range(0, SIZE.y-room_size.y)))
	create_room(room_pos, room_size)

func create_random_corridor():
	var num_points = utils.normal_limits(3, 1, 2, 6)
	var points = []
	var axis = int(rand_range(0,2))
	var point
	for i in range(num_points):
		if i == 0 :
			point = Vector2(int(rand_range(0, SIZE.x)), int(rand_range(0, SIZE.y)))
			points.append(point)
		else:
			point = Vector2()
			if axis == 0:
				point.x = points[len(points)-1].x
				point.y = int(rand_range(0, SIZE.y))
			else:
				point.x = int(rand_range(0, SIZE.x))
				point.y = points[len(points)-1].y
			axis = int(axis+1)%2
			points.append(point)
	create_corridor(points)

func create_random_entrance_exit():
	var available_rooms = room_list.duplicate()
	available_rooms.shuffle()
	var entrance_room = available_rooms.pop_back()
	var exit_room = available_rooms.pop_back()
	entrance = Vector2(int(rand_range(entrance_room.init_pos.x, entrance_room.init_pos.x + entrance_room.size.x)), int(rand_range(entrance_room.init_pos.y, entrance_room.init_pos.y + entrance_room.size.y)))
	exit = Vector2(int(rand_range(exit_room.init_pos.x, exit_room.init_pos.x + exit_room.size.x)), int(rand_range(exit_room.init_pos.y, exit_room.init_pos.y + exit_room.size.y)))

func create_random_position():
	var room = room_list[rand_range(0, len(room_list))]
	var random_pos = Vector2(int(rand_range(room.init_pos.x, room.init_pos.x + room.size.x)), int(rand_range(room.init_pos.y, room.init_pos.y + room.size.y)))
	return random_pos


# Prop generation

func generate_orbs():
	var orbs_per_room = int(float(ORBS_PER_LEVEL)/float(room_list.size())) + 1
	var orbs_remaining = ORBS_PER_LEVEL
	
	orb_locations = []
	
	for room in room_list:
		var orbs_in_room = min(orbs_per_room, orbs_remaining)

		while orbs_in_room > 0:
			var new_orb_position = Vector2(int(rand_range(room.init_pos.x, room.init_pos.x + room.size.x)), int(rand_range(room.init_pos.y, room.init_pos.y + room.size.y)))

			if not orb_locations.has(new_orb_position) and entrance != new_orb_position and exit != new_orb_position: 
				orb_locations.append(new_orb_position)
				orbs_remaining -= 1
				orbs_in_room -= 1


# Others

func print_map_data():
	for corridor in corridor_list:
		var text = "corridor: {"
		for point in corridor.points:
			text+="("+str(point.x)+", "+str(point.y)+")"
		text+="}"
		print(text)
	pass
