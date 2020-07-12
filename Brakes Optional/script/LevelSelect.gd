extends Node2D


func _on_Back_pressed():
	get_tree().change_scene("res://overlay/TitleScreen.tscn")

func _on_Track1_pressed():
	Global.level = 1
	get_tree().change_scene("res://MainNode.tscn")

func _on_Track2_pressed():
	Global.level = 2
	get_tree().change_scene("res://MainNode.tscn")

func _on_Track3_pressed():
	Global.level = 3
	get_tree().change_scene("res://MainNode.tscn")
	
func _on_Track4_pressed():
	Global.level = 4
	get_tree().change_scene("res://MainNode.tscn")
	
func _on_Track5_pressed():
	Global.level = 5
	get_tree().change_scene("res://MainNode.tscn")
