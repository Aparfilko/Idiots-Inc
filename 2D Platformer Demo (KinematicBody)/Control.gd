extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	#if Input.is_action_pressed("splitscreen"):
		#get_tree().change_scene("res://src/Main/Game.tscn")
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Start_pressed():
	get_tree().change_scene("res://src/Main/Game.tscn")


func _on_Quit_pressed():
	get_tree().quit()
	print("bye")
