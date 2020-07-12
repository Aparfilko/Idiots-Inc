extends Panel


onready var node = preload("res://Demo.tscn").instance()

func _ready():
	rect_size = OS.get_window_size()
	$Label.rect_size.x = OS.get_window_size().x
	$Comet.rect_position.x = OS.get_window_size().x /2 - 590
	$VBoxContainer.rect_position.x = OS.get_window_size().x /2 - 220
	$VBoxContainer.rect_position.y = OS.get_window_size().y - 200
	
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
