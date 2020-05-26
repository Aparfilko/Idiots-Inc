extends KinematicBody2D

#these values all relate to movement, subject to change
const MAXSPEED = 250
const ACCEL = 0.33
const DEACCEL = 0.33

var direction = Vector2()
var velocity = Vector2()
var speed = 0
var input = false

func _ready():
	pass


func _physics_process(delta):
	#grab input
	get_input()
	#deterime speed
	get_velocity(input)
	#move
	move_and_slide(velocity*speed)

#get the direction
func get_input():
	input = false
	direction = Vector2()
	#x axis
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	#y axis
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	#check if input was applied
	if direction.length_squared() > 0:
		input = true
	direction = direction.normalized()

#apply acceleration
func get_velocity(input):
	#input happened, accelerate
	if input:	
		speed = lerp(speed, MAXSPEED, ACCEL)
		velocity = direction
	#grab previous direction if no input, deaccelerate
	else:
		speed = lerp(speed, 0, DEACCEL)
		velocity = velocity
