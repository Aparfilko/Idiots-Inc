extends KinematicBody2D
signal death
#movement values
const ACCEL = 0.33
const MAXSPEED = 200
const HEALSPEED = 0.033
const GENEROUS = 5
var speed = 0
var velocity = Vector2()
var direction = Vector2()
var impulse
var maxSpeedActual

#health values
var light = false
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
		print("dead")
		speed = lerp(speed, 0, ACCEL)
	else:
		get_impulse()
	#move
	move_and_slide(velocity)
	change_z()


#catcher function to make shadowed must receive
func lit_up():
	light = false



func get_impulse():
	impulse = Vector2(0,0)
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
	#some bullshit right here

	impulse = impulse.normalized()
	#if impulse directed, go that direction and speed up
	if impulse.length_squared() > 0:
		speed = lerp(speed, MAXSPEED, ACCEL)
		direction = impulse
	#no impulse, keep going previous direction and slow down
	else:
		speed = lerp(speed, 0, ACCEL)
	#finish by applying velocity
	velocity = direction*speed

#changes the z level, rn it can be done automatically with keys 'q' or 'e',
#will change this to be only done when there is a floor above or below the current
#z level
func change_z():
	if Input.is_action_just_pressed("ui_page_up") and Input.is_action_just_pressed("ui_page_down"):
		pass
	elif Input.is_action_just_pressed("ui_page_up"):
		self.set_z_index(self.get_z_index() + 2)
		self.set_scale(self.get_scale()*1.1)
	elif Input.is_action_just_pressed("ui_page_down"):
		self.set_z_index(self.get_z_index() - 2)
		self.set_scale(self.get_scale()/1.1)
	else:
		pass
#name says it all
func check_light():
	pass
