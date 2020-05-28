extends KinematicBody2D
signal death
#movement values, deprecated for now
#const ACCEL = 0.2
#const DEACCEL = 0.2
#const TURNACCEL = 0.33
#const MAXSPEED = 200
#var speed = 0
const HEALSPEED = 0.033
const GENEROUS = 5
#health values
var light = false
#this is also the transparency
var health = 100
var dead = false

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
	#check if health 0, if not then die and let everyone know you are dead
	if health == 0 and not dead:
		dead = true
	#check if dead, if not then move, otherwise slow down
	if dead:
		speed = lerp(speed, 0, ACCEL)
	else:
		get_impulse()
	#deterime speed
	#move
	move_and_slide(velocity)


#catcher function to make shadowed must receive
func lit_up():
	light = false



func get_impulse():
#	impulse = Vector2(0,0)
#	#x axis
#	if Input.is_action_pressed("ui_right"):
#		impulse.x += 1
#	if Input.is_action_pressed("ui_left"):
#		impulse.x -= 1
#	#y axis
#	if Input.is_action_pressed("ui_up"):
#		impulse.y -= 1
#	if Input.is_action_pressed("ui_down"):
#		impulse.y += 1
#	#some bullshit right here
#
#	impulse = impulse.normalized()
#	if impulse.length_squared() > 0:
#		#below value exists because it takes a bit for velocity.length() to reach zero, 
#		#if so direction immediately equals impulse
#		if velocity.length_squared() < GENEROUS:
#			direction = impulse
#		#no? then apply turn acceleration
#		else:
#			direction = direction.linear_interpolate(impulse, TURNACCEL)
#		speed = lerp(speed, MAXSPEED, ACCEL)
#	#no impulse means slow down
#	else:
#		speed = lerp(speed, 0, DEACCEL)
#	#finish by applying velocity
#	velocity = direction*speed
#		pass
