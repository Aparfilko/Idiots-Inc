extends KinematicBody

func _ready():
	pass # Replace with function body.

func _input(event):
	if(event.is_action_pressed("ui_up")):
		translate(Vector3(0,0,1));
