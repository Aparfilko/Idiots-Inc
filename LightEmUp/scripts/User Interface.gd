extends Control


# Declare member variables here. Examples:

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	connect("mouse_exited", self, "_hiding")
	connect("mouse_entered", self, "_showing")


func _process(_dt):
	$Pointer.set_position(get_global_mouse_position())
	print(get_global_mouse_position())
#
func _hiding():
	print("go away")
	$Pointer/Sprite.visible = false

func _showing():
	$Pointer/Sprite.visible = true
