extends PopupDialog


var refManagerLevel


func _on_button_hover():
	$buttonSfx/hover.play()
func _on_button_pressed():
	$buttonSfx/click.play()
func _on_Next_pressed():
	_on_button_pressed()
	get_tree().paused = false
	get_tree().get_root().get_node("MainNode/ManagerLevel").next_level()
	visible = false
	pass

func _on_Quit_pressed():
	_on_button_pressed()
	get_tree().paused = false
	get_tree().change_scene("res://overlay/TitleScreen.tscn")

func _input(_event):
	if Input.is_action_just_pressed("ui_page_up"):
		get_parent().get_node("Pausenode").halt = true
		$AudioStreamPlayer/.play()
		get_tree().paused = true
		popup_centered()
		$AudioStreamPlayer/.play()
