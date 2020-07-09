extends Node2D


func _on_Last_pressed():
	get_parent().get_parent().choose_level(-1)
