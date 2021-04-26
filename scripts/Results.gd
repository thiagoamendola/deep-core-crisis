extends Control

const Game = preload("Game.gd")

onready var global_vars = get_node("/root/GlobalVariables")

func _ready():
	$TimeLabel.text = "Time Left: "+str(int(global_vars.remaining_time))
	$OrbsLabel.text = "Orbs Collected: "+str(global_vars.collected_orbs)+"/"+str(Game.TOTAL_ORBS_FOR_VICTORY)
	
	if global_vars.collected_orbs >= Game.TOTAL_ORBS_FOR_VICTORY and global_vars.reached_core:
		$VictoryLabel.visible = true
	else:
		$DefeatLabel.visible = true


func _on_Button_pressed():
	get_tree().change_scene("res://Title.tscn")
