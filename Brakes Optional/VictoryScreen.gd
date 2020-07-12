extends Node2D


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		$global.level=0;
		get_tree().change_scene("res://MainNode.tscn")
