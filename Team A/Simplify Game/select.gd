extends StaticBody2D
signal clicked(node)

func _ready():
	connect("clicked", get_parent(), "_select_word")
	
func _input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("click"):
		emit_signal("clicked", self)
