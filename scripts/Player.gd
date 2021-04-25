extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _physics_process(delta) -> void:
	var direction: = Vector2 (( Input.get_action_strength( "move_right" ) - Input.get_action_strength("move_left")), 
	(Input.get_action_strength("move_down")-Input.get_action_strength( "move_up" )))
	
	var speed = 300
	var velocity = speed*direction
	velocity = move_and_slide(velocity)
	
