extends KinematicBody2D

const accel = 10
onready var realAcc = false
#collisions
onready var colBaseEx = Vector2(15, 37)
onready var colSelectEx = Vector2(37,37)

onready var offset = Vector2(-55,-10)
onready var basePos = get_position()
onready var pos = basePos
onready var held = false
#handled in socket script
onready var hover = false
onready var plugged = false

func _ready():
	set_collision(colBaseEx)

#changes collsion rects of normal
func set_collision(vec):
	$normal.shape.set_extents(vec)

func _physics_process(dt):
	#follow mouse when held
	if held:
		position = position + get_local_mouse_position()
	#go back if not by plug
	else:
		#snap to 
		if not realAcc:
			position = position.linear_interpolate(pos, accel*dt)
		else:
			position = pos
		
func _input_event(_body, _event, _shape_idx):
	#only pick self, and if just clicked
	#when doing so, change animation and eliminite nice collision
	if Input.is_action_just_pressed("click") and not held and $Timer.is_stopped():
		pickUp()
		
func _input(event):
	if held:
		if event.is_action_pressed("click"):
			if hover:
				plugIn()
			else:
				plugOut()
			$Timer.start()	
		elif event.is_action_pressed("unplug"):
			plugOut()
			$Timer.start()	

func plugIn():
	z_index -= 1
	held = false
	realAcc = true
	set_collision(colSelectEx)
	$normal.set_disabled(false)
	$disable.set_disabled(true)
	if pos.y < -100:
		$AnimatedSprite.play("plugged")
	else:
		$AnimatedSprite.play("pluggedBelow")
	$Timer.start()
	plugged = true
	
func plugOut():
	z_index -= 1
	held = false
	realAcc = false
	$normal.set_disabled(false)
	set_collision(colBaseEx)
	$disable.set_disabled(false)
	$AnimatedSprite.play("default")
	held = false
	plugged = false
	
func pickUp():
	z_index += 1
	held = true
	realAcc = false
	set_collision(colSelectEx)
	$AnimatedSprite.play("selected")
	$disable.set_disabled(true)
	$normal.set_disabled(true)
	plugged = false
