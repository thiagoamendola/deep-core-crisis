extends Node2D

var taken = false

func _on_Area2D_body_entered(body):
	if not taken and body is preload("res://scripts/Player.gd"):
		taken = true
		get_parent().get_parent().collected_orbs += 1
		queue_free()
