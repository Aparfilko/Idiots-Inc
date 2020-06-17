extends KinematicBody
onready var sensitivity = 0.1
onready var angle = 0

func _ready():
	pass

func _input(event):
	#is mouse moving?
	if event is InputEventMouseMotion:
		$xHook.rotate_y(deg2rad(-event.relative.x * sensitivity))
		var vert = -event.relative.y * sensitivity
		if vert + angle < 90 and vert + angle > -90:
			$xHook/yHook.rotate_x(deg2rad(vert))
			angle += vert
			
