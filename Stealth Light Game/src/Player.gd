extends KinematicBody2D
signal death

const ACCEL = 0.2
const DEACCEL = 0.2
const TURNACCEL = 0.33
const MAXSPEED = 200
const HEALSPEED = 0.033
const GENEROUS = 5
#these values all relate to movement, subject to change
var maxSpeedActual = MAXSPEED
var impulse = Vector2()
var direction = Vector2()
var velocity = Vector2()
var speed = 0
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
	else:
		light = false
		health = lerp(health, 100, HEALSPEED)
	#check if health 0, if not then die and let everyone know you are dead
	if health == 0 and not dead:
		dead = true
		emit_signal("death")
	#if dead then slow down! otherwise get input
	if dead:
		speed = lerp(speed, 0, ACCEL)
	else:
		pass



#catcher function to make shadowed must receive
func lit_up():
	light = false
