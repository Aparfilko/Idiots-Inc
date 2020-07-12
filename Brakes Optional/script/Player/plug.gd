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
	pos = shake(0,20)
	set_position(pos)

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
		if pos == position:
			z_index = -2
		else:
			position = position.linear_interpolate(pos, accel*dt)
			
func _input(_event):
	if Input.is_action_just_released("click") and held:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		if hover:
			plugIn()
		else:
			plugOut()
				
				
func _input_event(_body, _event, _shape_idx):
	#only pick self, and if just clicked
	#when doing so, change animation and eliminite nice collision
	if not $AnimatedSprite.get_animation().match("hell"):
		if Input.is_action_just_pressed("click") and not held:
			pickUp()
		elif Input.is_action_just_pressed("unplug") and plugged:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			plugOut()
#

func plugIn():
	held = false
	if pos.y < -100:
		$AnimatedSprite.play("plugged")
	else:
		$AnimatedSprite.play("pluggedBelow")
	plugged = true
	$disable.set_disabled(true)
	$select.set_disabled(true)
	$normal.set_disabled(false)
	print(name + " plugs in")
	emit_signal("read")
	
func plugOut():
	pos = shake(0, 20)
	held = false
	$AnimatedSprite.play("default")
	plugged = false
	$disable.set_disabled(false)
	$select.set_disabled(true)
	$normal.set_disabled(false)
	print(name + " goes back home")
	emit_signal("gone")

	
func pickUp():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	z_index = 0
	held = true
	$AnimatedSprite.play("selected")
	plugged = false
	$disable.set_disabled(true)
	$select.set_disabled(false)
	$normal.set_disabled(true)
	emit_signal("gone")
	print(name + " picked up")
	
func shake(x, y):
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	return basePos + Vector2(0, rng.randf_range(-y,y))
