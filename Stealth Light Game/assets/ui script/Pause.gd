extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = false
	visible = false
	

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		var pausestate = not get_tree().paused
		get_tree().paused = pausestate
		visible = pausestate
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ResumeButton_pressed():
	get_tree().paused = false
	visible = false


func _on_ToStart_pressed():
	get_tree().change_scene("res://baseUI.tscn")


func _on_MusicToggle_pressed():
	pass # Replace with function body.
