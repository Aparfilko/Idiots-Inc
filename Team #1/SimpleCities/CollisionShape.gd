extends CollisionShape

func _ready():
	set_process_input(true)
func _input(event):
	if(event.type == InputEvent.MOUSE_BUTTON && event.button_index == BUTTON_LEFT):
		print("Clicked!")
