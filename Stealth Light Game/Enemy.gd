class_name Enemy
extends KinematicBody2D

enum State {RELAXED,SUS,ALERT}
var _state = State.RELAXED
var direction = Vector2()

func _ready():
	pass


func _process(_delta):
	#if player_collision hits first enemy_collision
		#_state = State.SUS
	#if player_collision hits second enemy_collision
		#_state = State.ALERT
		
		#BUT HOW TO CODE THIS
		
	if _state == State.RELAXED:
		pass
	elif _state == State.SUS:
		pass
		#for some amount of time
			#don't change speed but follow the player for a bit
	elif _state == State.ALERT:
		pass
		#aggressive action/attack the player
		#speed up and follow the player
		#for some amount of time after line of sight breaks
			#look for the player based on available pathways
	else:
		_state = State.RELAXED
