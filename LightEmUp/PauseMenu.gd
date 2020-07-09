extends Control


onready var resume_button = $VBoxContainer/ResumeButton

func _ready():
	visible = false

func close():
	visible = false

func open():
	visible = true
	resume_button.ui_cancel()

func _on_Resume_pressed():
	get_tree().paused = false
	visible = false

func _on_Quit_pressed():
	if get_parent().get_parent().name == "Splitscreen":
		# We need to clean up a little bit first to avoid Viewport errors.
		$"../../Black/SplitContainer/ViewportContainer1".free()
	get_tree().quit()

## anjali's changes start here
func _on_Menu_pressed():
	if get_parent().get_parent().name == "Splitscreen":
		# fuck yeah I'm stealing their clean up code, do I LOOK like a moral woman?
		$"../../Black/SplitContainer/ViewportContainer1".free()
	get_tree().paused = false
	visible = false
	get_tree().change_scene("res://src/Main/StartScreen.tscn")
