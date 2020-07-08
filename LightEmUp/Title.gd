extends Node2D


func _on_Level_Select_pressed():
	get_child(0).offset.y =1000
	#get_tree().change_scene('res://LevelSelect.tscn')

func _on_Quit_pressed():
	get_tree().quit()
