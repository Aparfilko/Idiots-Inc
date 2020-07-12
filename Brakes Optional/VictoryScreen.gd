extends Node2D


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		Global.level=0;
		get_tree().change_scene("res://MainNode.tscn")
