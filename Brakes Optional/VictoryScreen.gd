extends Node2D


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().change_scene("res://MainNode.tscn")


func _on_Button_pressed():
	get_tree().change_scene("res://MainNode.tscn")
