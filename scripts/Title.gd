extends Control

func _ready():
	pass # Replace with function body.

func _input(event):
	if event is InputEventKey and event.pressed:
		get_tree().change_scene("res://Game.tscn")


func _on_StartButton_pressed():
	get_tree().change_scene("res://Game.tscn")
