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

func _on_Resume_pressed(): #resume
	visible = false


func _on_Restart_pressed(): #restart track
	pass # Replace with function body.


func _on_BackToStart_pressed(): #Return to either start screen or whatever main 
	#we develop
	#visible = not visible
	pass # Replace with function body.

func _on_Quit_pressed(): #quit game. no dialogue to confirm that yet.
	get_tree().quit();
