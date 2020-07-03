extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
func _input(_event):
	if Input.is_action_just_pressed("ui_cancel"):
		visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Resume_pressed():
	visible = false

func _on_toMenu_pressed():
	#visible = not visible
	pass # Replace with function body.

func _on_Mute_pressed():
	if get_parent().get_parent().get_child(5).get_stream_paused() == false:
		get_parent().get_parent().get_child(5).set_stream_paused(true) 
		get_node("Panel/VBoxContainer/Mute").set_text("Play Music")
	else:
		get_parent().get_parent().get_child(5).set_stream_paused(false) 
		get_node("Panel/VBoxContainer/Mute").set_text("Mute Music")
		


func _on_Quit_pressed():
	get_tree().quit()
