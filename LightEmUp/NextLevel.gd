extends Node2D


func _on_Next_pressed():
	get_parent().get_parent().get_parent().get_node("LevelSelect").choose_level(1)
