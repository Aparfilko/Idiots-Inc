class_name Enemy
extends KinematicBody2D

#enum State {RELAXED,SUS,ALERT}
#var _state = State.RELAXED
enum State {PATROL,FLASH}
var _state = State.PATROL
var direction = Vector2()

const time_run = 2000
const time_flash = 100
const time_pause = 500
var time = 0

const angle = deg2rad(20)
onready var vision_cone = get_node("VisionCone")
const vision_dist_patrol = 1000 #fine tune later
const vision_dist_final = 40*6 #fine tune later
var vision_dist = vision_dist_patrol

func _physics_process(_delta):
	for i in range(-angle,angle):
		vision_cone.cast_to(2*vision_dist*tan(i),vision_dist)
		for i in get_slide_count():
			var collision = get_slide_collision(i)
			if collision.collider.name.begins_with ("Player"): #or vision_cone hits ("Player"):
				_state = State.FLASH
#			
#			short pause
#			alert music
#			if collision occurs hurt the player
		
	if _state == State.PATROL:
		pass
#		walk from node to node, pausing at each node and looking at the current node
		vision_dist = vision_dist_patrol
	elif _state == State.FLASH:
		pass
#		for time = time_run 
#			don't change speed but follow the player for a bit
#			vision_dist = vision_dist_sus
#			if player is still in sus range after a short pause
#				time = 0
#			else
#				time += delta
		time = 0
		_state = State.RELAXED
#	elif _state == State.ALERT:
#		pass
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
