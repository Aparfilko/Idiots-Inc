extends KinematicBody
onready var sensitivity = 0.1
onready var camera_angle = Vector2()

var direction
var velocity
onready var speed = 0
const MAXSPEED = 1200
const ACCEL = 0.1

func _ready():
	direction = Vector3()

#mouse movement
func _input(event):
	#is mouse moving?
	if event is InputEventMouseMotion:
		var camera_change = Vector2(-event.relative * sensitivity)
		self.rotate_y(deg2rad(camera_change.x))
		camera_angle.x = (camera_angle.x + camera_change.x)
		if camera_change.y + camera_angle.y < 90 and camera_change.y + camera_angle.y > -90:
			$yHook.rotate_x(deg2rad(camera_change.y))
			camera_angle.y += camera_change.y

#general movement
func _physics_process(dt):
	#get the movement wanted
	get_impulse(dt)
	move_and_slide(velocity)
	
#
func get_impulse(dt):
	var impulse = Vector2()
	#x axis
	if Input.is_action_pressed("ui_right"):
		impulse.x += 1
	if Input.is_action_pressed("ui_left"):
		impulse.x -= 1
	#y axis
	if Input.is_action_pressed("ui_up"):
		impulse.y -= 1
	if Input.is_action_pressed("ui_down"):
		impulse.y += 1
	impulse = impulse.normalized().rotated(deg2rad(-camera_angle.x))
	if impulse.length_squared() > 0:
		speed = lerp(speed, MAXSPEED, ACCEL)
		direction = Vector3(impulse.x, 0, impulse.y)
	else:
		speed = lerp(speed, 0, ACCEL)
	velocity = direction * speed * dt
		
	
	

