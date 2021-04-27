extends Area2D

func _on_EndingDetector_body_entered(body):
	if body is preload("res://scripts/Player.gd"):
		get_parent().next_map()
