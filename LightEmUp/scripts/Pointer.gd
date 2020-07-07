extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	get_parent().connect("mouse_exited", self, "_hiding")
	get_parent().connect("mouse_entered", self, "_showing")


func _process(delta):
	set_position(get_global_mouse_position())
	
func _hiding():
	print("go away")
	$Sprite.visible = false
	
func _showing():
	$Sprite.visible = true
