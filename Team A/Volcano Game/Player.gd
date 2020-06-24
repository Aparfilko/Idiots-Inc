extends KinematicBody
onready var sensitivity = 0.1
onready var camera_angle = Vector2()

const jump = 40
const term = -40
onready var jumpLow = 0.2
onready var fall = 0.4
onready var gravity = 4

onready var direction = Vector3()
onready var velocity = Vector3()
onready var up_direction = Vector3(0,1,0)
onready var speed = 0
const MAXSPEED = 30
const ACCEL = 0.1

onready var holding = false
onready var pick = false
onready var prevNode = self
var itemNode

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
			camera_angle.x += -360
		if camera_change.y + camera_angle.y < 90 and camera_change.y + camera_angle.y > -90:
			$yHook.rotate_x(deg2rad(camera_change.y))
			camera_angle.y += camera_change.y
		
	
#general movement
func _physics_process(_dt):
	#get the movement wanted
	get_impulse()
	jumpy()
	move_and_slide(velocity, up_direction)
	if Input.is_action_just_pressed("pickup"):
		#drop item
		if holding:
			$joint.queue_free()
			holding = false
		#pick up item
		elif pick:
			add_joint(self)
			$joint.set_node_a(self.get_path())
			$joint.set_node_b(itemNode.get_path())
			itemNode = prevNode
			holding = true
		#nothing happens
		else:
			pass
		
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
	if Input.is_action_just_pressed("ui_select") and is_on_floor() == true:
			velocity.y = jump



func _no_item(_body):
	$yHook/crosshair.play("default")
	pick = false


func pick_up(body):
	if body.is_in_group("pickup") and not holding:
		$yHook/crosshair.play("select")
		pick = true
		itemNode = body
		
func add_joint(body):
	var joint = Generic6DOFJoint.new()
	joint.set_name("joint")
	body.add_child(joint)
