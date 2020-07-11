extends KinematicBody2D

const accel = 10
signal read()
signal gone()
onready var realAcc = false
#collisions
onready var colSelectEx = Vector2(37,37)

onready var offset = Vector2(-55,-10)
onready var basePos = get_position()
onready var pos = basePos
onready var held = false
#handled in socket script
onready var hover = false
onready var plugged = false

func _ready():
	set_collision(colSelectEx)

#changes collsion rects of normal
func set_collision(vec):
	$normal.shape.set_extents(vec)

func _physics_process(dt):
	#follow mouse when held
	if held:
		position = position + get_local_mouse_position()
	#go back if not by plug
	elif plugged:
		position = pos
	else:
		position = position.linear_interpolate(pos, accel*dt)
		
func _input_event(_body, _event, _shape_idx):
	#only pick self, and if just clicked
	#when doing so, change animation and eliminite nice collision
	if Input.is_action_just_pressed("click"):
		pickUp()
	elif Input.is_action_just_released("click"):
		if hover:
			plugIn()
		else:
			plugOut()
	elif Input.is_action_just_pressed("unplug"):
		plugOut()
#

func plugIn():
	z_index = 1
	held = false
	$disable.set_disabled(true)
	if pos.y < -100:
		$AnimatedSprite.play("plugged")
	else:
		$AnimatedSprite.play("pluggedBelow")
#	$Timer.start()
	plugged = true
	emit_signal("read")
	
func plugOut():
	pos = basePos
	z_index = 1
	held = false
	$disable.set_disabled(false)
	$AnimatedSprite.play("default")
	plugged = false
	emit_signal("gone")
	
func pickUp():
	z_index = 2
	held = true
	$AnimatedSprite.play("selected")
	$disable.set_disabled(true)
	plugged = false
	emit_signal("gone")
