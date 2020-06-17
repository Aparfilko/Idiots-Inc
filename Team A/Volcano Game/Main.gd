extends Spatial


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

#quit by pressing escape, temp until we have a pause menu
func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().quit()
