extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
func _input(_event):
	if Input.is_action_just_pressed("ui_cancel"):
		visible = not visible

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
