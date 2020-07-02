extends StaticBody2D
signal clicked(node)

func _ready():
	$CollisionShape2D.set_disabled(false)
	set_pickable(true)
	connect("clicked", get_parent(), "_selectWord")
	
func _input_event(_viewport, _event, _shape_idx):
	if Input.is_action_just_pressed("click"):
		emit_signal("clicked", self)
