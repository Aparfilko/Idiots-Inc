extends Panel


onready var node = preload("res://Demo.tscn").instance()

func _ready():
	pass
	
func _on_button_hover():
	$buttonSfx/hover.play()
func _on_button_pressed():
	$buttonSfx/click.play()

#startGame
func _on_start_pressed():
	visible = false
	get_parent().add_child(node)
	
func _on_LevelSelect_pressed():
	get_tree().change_scene("res://overlay/LevelSelect.tscn")

#exit, probably should have a dialog box?
func _on_LeabDisPwace_pressed(): #uwu
	get_tree().quit();
