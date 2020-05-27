class_name Enemy
extends KinematicBody2D

enum State {RELAXED,SUS,ALERT}
var _state = State.RELAXED
var direction = Vector2()

const time_sus = 5
const time_alert = 20
var time = 0

const angle = 20
onready var vision_cone = $VisionCone
var vision_distance = 20

func _process(_delta):
	for i in range(deg2rad(-angle),deg2rad(angle)):
		pass
		#sweep in front of enemy over i with vision_distance x 
		#if vision_cone hits player and _state == State.RELAXED:
			#_state = State.SUS
			#distance = x+y
		#elif vision_cone hits player and _state == State.SUS:
			#_state = State.ALERT
		
	if _state == State.RELAXED:
		pass
		#walk predetermined path
	elif _state == State.SUS:
		pass
		#for time < time_sus:
			#don't change speed but follow the player for a bit
			#if player is still in sus range
				#time = 0
			#else
				#time += delta
		time = 0
		_state = State.RELAXED
		#vision_distance = x
	elif _state == State.ALERT:
		pass
		#for time < time_alert:
			#aggressive action/attack the player
			#speed up and follow the player
			#if player is still in alert range
				#time = 0
			#else:
				#time += delta
		time = 0
		_state = State.SUS
	else:
		_state = State.RELAXED
	
