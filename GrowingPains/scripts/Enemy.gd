extends KinematicBody2D


const grav = 1000
const accel = 0.5
onready var vel = Vector2()
onready var speed = 7500
onready var jump = 30000
onready var lr = 1; #0=left,1=right

func get_class():
	return "Enemy";

func _physics_process(dt):
	if not $form.is_disabled():
		get_movement(dt)
	var pos0=position;
	move_and_slide(vel,Vector2(0,-1))
	var pos1=position;
	$leftBound.position-=pos1-pos0;
	$rightBound.position-=pos1-pos0;
	$leftJumpCheck.add_exception(get_parent().get_node("Player"))
	$rightJumpCheck.add_exception(get_parent().get_node("Player"))

#controls movement and jumping
func get_movement(dt):
	if $leftBound.position.x>0:
		lr=1;
	if $rightBound.position.x<0:
		lr=0;
	if is_on_floor():
		var dir=0;
		if lr:
			dir = speed * dt
		else:
			dir = -speed * dt
		#need this to make movement feel more natural
		if dir * vel.x >= -speed * speed* dt / 100:
			vel.x = lerp(vel.x, dir, accel)
		else:
			vel.x = lerp(vel.x, 0, accel)
		#scan for jumps
		vel.y = 0
		if lr and $rightJumpCheck.get_collider():
			vel.y = -jump * dt
		elif not lr and $leftJumpCheck.get_collider():
			vel.y = -jump * dt
	#if in air, then you must fall
	else:
		vel.y += grav * dt

#when attacked, die
func death():
	$form.set_disabled(true)
	$Timer.start()

func _on_Timer_timeout():
	queue_free()
