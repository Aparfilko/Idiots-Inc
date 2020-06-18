extends KinematicBody
onready var sensitivity = 0.1
onready var camera_angle = Vector2()

const jump = 50
const term = -70
onready var jumpLow = 0.2
onready var fall = 0.4
onready var gravity = 6

onready var direction = Vector3()
onready var velocity = Vector3()
onready var speed = 0
const MAXSPEED = 30
const ACCEL = 0.1

onready var position = Vector3(-25,1,0)
func _ready():
	pass

#mouse movement
func _input(event):
	#is mouse moving?
	if event is InputEventMouseMotion:
		var camera_change = Vector2(-event.relative * sensitivity)
		self.rotate_y(deg2rad(camera_change.x))
		camera_angle.x = (camera_angle.x + camera_change.x)
		if camera_angle.x > 360:
			camera_angle += -360
		if camera_change.y + camera_angle.y < 90 and camera_change.y + camera_angle.y > -90:
			$yHook.rotate_x(deg2rad(camera_change.y))
			camera_angle.y += camera_change.y

#general movement
func _physics_process(_dt):
	#get the movement wanted
	get_impulse()
	jumpy()
	move_and_slide(velocity)
	
#
func get_impulse():
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
		direction = Vector3(impulse.x, direction.y, impulse.y)
	else:
		speed = lerp(speed, 0, ACCEL)
	velocity = Vector3(direction.x * speed , velocity.y, direction.z * speed)
		
func jumpy():
	if velocity.y <= 0: #player is falling
		if velocity.y > term and not is_on_wall():
			velocity.y += -gravity * fall
	elif velocity.y > 0: #jumping
		if Input.is_action_pressed("ui_select"):
			velocity.y += -gravity * jumpLow
		else:
			velocity.y += -gravity * fall
	if Input.is_action_just_pressed("ui_select"):
		if (is_on_wall()):
			velocity.y = jump
