class_name Enemy
extends KinematicBody2D

#enum State {RELAXED,SUS,ALERT}
#var _state = State.RELAXED
enum State {PATROL,FLASH}
var _state = State.PATROL
var direction = Vector2()

const time_run = 3000
const time_flash = 100
const time_pause = 1000
var time = 0

const angle = deg2rad(30)
onready var vision_cone = get_node("VisionCone")
const vision_dist = 200 #fine tune
const ouch = 5000 #doesn't matter as long as it's functionally infinite

func _physics_process(_delta):
	if _state == State.PATROL:
		for i in range(-angle,angle):
			vision_cone.cast_to(vision_dist*tan(i),vision_dist)
#			raycast collision check
		
		for i in get_slide_count():
			var collision = get_slide_collision(i)
			if collision.collider.name.begins_with ("Player"): #or vision_cone hits ("Player"):
				_state = State.FLASH
			
#		walk from node to node, pausing at each node and looking at the next node
	elif _state == State.FLASH:
		for i in time < time_run:
			time += _delta
			vision_cone.cast_to(0,0)
#			enemy sprite goes between lighter and normal colors for time_run
#			sound cue of increasing pitch
		time = 0
#		raycast in all directions with a light for time_flash
#		if the raycast hit the player:
#			decrease player HP
#		wait for time_pause
		_state = State.PATROL
