class_name Enemy
extends KinematicBody2D

enum State {RELAXED,SUS,ALERT}
var _state = State.RELAXED
var direction = Vector2()

const time_sus = 5
const time_alert = 20
var time = 0

const angle = deg2rad(20)
onready var vision_cone = get_node("VisionCone")
const vision_dist_relaxed = 40*7 #fine tune later
const vision_dist_sus = 40*6 #fine tune later
const vision_dist_not_relaxed = 40*5 #fine tune later
var vision_dist = vision_dist_relaxed

func _process(_delta):
	for i in range(-angle,angle):
		vision_cone.cast_to(2*vision_dist*tan(i),vision_dist)
#		if vision_cone hits player and _state == State.RELAXED:
#			_state = State.SUS
#			short pause
#			? sound
#		elif vision_cone hits player and _state == State.SUS:
#			_state = State.ALERT
#			short pause
#			alert music
#			if collision occurs hurt the player
		
	if _state == State.RELAXED:
		pass
#		walk predetermined path
#		vision_dist = vision_dist_relaxed
	elif _state == State.SUS:
		pass
#		for time < time_sus:
#			don't change speed but follow the player for a bit
#			vision_dist = vision_dist_sus
#			if player is still in sus range after a short pause
#				time = 0
#			else
#				time += delta
		time = 0
		_state = State.RELAXED
	elif _state == State.ALERT:
		pass
#		for time < time_alert:
#			aggressive action/attack the player
#			speed up and follow the player
#			if player is still in alert range
#				time = 0
#			else:
#				time += delta
		time = 0
		_state = State.SUS
	else:
		_state = State.RELAXED


#code I used to test collision in the other project
#for i in get_slide_count():
#	var collision = get_slide_collision(i)
#	if collision.collider.name.begins_with ("Enemy"):
