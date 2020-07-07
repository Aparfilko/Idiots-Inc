extends KinematicBody2D

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(_dt):
	set_position(get_global_mouse_position())
	
