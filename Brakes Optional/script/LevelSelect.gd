extends Node2D


func _on_Back_pressed():
	get_tree().change_scene("res://overlay/TitleScreen.tscn")

func _on_Tutorial_pressed():
	pass

func _on_Track1_pressed():
	get_tree().get_root().get_node("ManagerLevel").choose_level(1)

func _on_Track2_pressed():
	get_tree().get_root().get_node("ManagerLevel").choose_level(2)

func _on_Track3_pressed():
	get_tree().get_root().get_node("ManagerLevel").choose_level(3)
