extends PopupDialog


var refManagerLevel

func _on_Next_pressed():
	get_tree().get_root().get_node("MainNode/ManagerLevel").next_level()
	visible = false
	pass

func _on_Quit_pressed():
	get_tree().quit()

func _input(event):
	if Input.is_action_just_pressed("ui_page_up"):
		popup_centered()
