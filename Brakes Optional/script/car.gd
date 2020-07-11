extends KinematicBody

func _ready():
	pass # Replace with function body.

func _input(event):
	if(event.is_action_pressed("w")):
		translate(Vector3(0,0,-1));
	if(event.is_action_pressed("s")):
		translate(Vector3(0,0,1));
	if(event.is_action_pressed("a")):
		translate(Vector3(-1,0,0));
	if(event.is_action_pressed("d")):
		translate(Vector3(1,0,0));
