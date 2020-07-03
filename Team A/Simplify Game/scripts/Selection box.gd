extends Area2D



onready var reset = false
var b
var c

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", get_parent(), "_in_Select", [self])
	connect("body_exited", get_parent(), "_out_Select", [self])

func _input_event(_viewport, _event, _shape_idx):
	if Input.is_action_just_pressed("click") and reset:
		c.set_position(b)
		reset = false

func goBack(basecard):
	reset = true
	b = basecard[0]
	c = basecard[1]

