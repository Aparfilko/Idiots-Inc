extends Node2D


func _on_Back_pressed():
	get_tree().change_scene("res://overlay/TitleScreen.tscn")

func _on_Tutorial_pressed():
	pass

func _on_Track1_pressed():
	get_tree().change_scene("res://level/Track1.tscn")

func _on_Track2_pressed():
	get_tree().change_scene("res://level/Track2.tscn")

func _on_Track3_pressed():
	get_tree().change_scene("res://level/Track3.tscn")
