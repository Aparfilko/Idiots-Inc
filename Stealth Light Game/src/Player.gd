extends KinematicBody2D
signal death

const ACCEL = 0.33
const DEACCEL = 0.33
const MAXSPEED = 250
const HEALSPEED = 0.033
#these values all relate to movement, subject to change
var maxSpeedActual = MAXSPEED
var direction = Vector2()
var velocity = Vector2()
var speed = 0
#health values
var light = false
#this is also the transparency
var health = 100

func _ready():
	pass


func _physics_process(delta):
	#in light? take damage and slow down
	if light:
		health = lerp(health, 0, HEALSPEED)
		maxSpeedActual = MAXSPEED/2
	else:
		light = false
		health = lerp(health, 100, HEALSPEED)
		maxSpeedActual = MAXSPEED
	#check if alive, if not then die and slow down, otherwise get input
	if health == 0:
		emit_signal("death")
		speed = lerp(speed, 0, DEACCEL)
	else:
		get_input()
	#deterime speed
	#move
	move_and_slide(velocity*speed)
	
	

#get the direction+speed
func get_input():
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
	#check if input was applied, apply speed if so
	#otherwise, use previous direction and apply deacceleration
	if direction.length_squared() > 0:
		speed = lerp(speed, maxSpeedActual, ACCEL)
		velocity = direction.normalized()
	else:
		speed = lerp(speed, 0, DEACCEL)



#catcher function to make shadowed must receive
func lit_up():
	light = false
