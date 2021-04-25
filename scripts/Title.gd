extends Node2D

func _ready():
	pass # Replace with function body.

func _input(event):
	if event is InputEventKey and event.pressed:
		get_tree().change_scene("res://Game.tscn")
