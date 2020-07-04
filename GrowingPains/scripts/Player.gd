extends KinematicBody2D


const speed = [15000, 30000, 7500] 
const grav = 1000
const accel = 0.3
onready var vel = Vector2()
onready var age = 0
onready var jump = [20000, 25000, 10000]



func _ready():
	#bind inputs here
	get_node("form"+String(age)).set_disabled(false)
	bind_key(KEY_A, "left")
	bind_key(KEY_D, "right")
	bind_key(KEY_SPACE, "jump")
	bind_key(KEY_CONTROL, "age")


func _physics_process(dt):
	scan_age()
	get_movement(dt)
	move_and_slide(vel)
	

#controls movement and jumping
func get_movement(dt):
	#simple move left or move right
	var dir = 0
	if Input.is_action_pressed("left"):
		dir -= speed[age] * dt
	if Input.is_action_pressed("right"):
		dir += speed[age] * dt
	#don't have any air control lol
	if is_on_wall():
		#need this to make movement feel more natural
		if dir * vel.x >= -10000:
			vel.x = lerp(vel.x, dir, accel)
		else:
			vel.x = lerp(vel.x, 0, accel)
		#scan for jumps
		vel.y = 0
		if Input.is_action_pressed("jump"):
			vel.y = -jump[age] * dt
	#if in air, then you must fall
	else:
		vel.y += grav * dt
	

#binds keyboard keys to a new action, probably won't work for binding multiple keys
#to the same thing
func bind_key(key, name):
	var event = InputEventKey.new()
	event.scancode = key
	InputMap.add_action(name)
	InputMap.action_add_event(name, event)

#press age to go to the next form
func scan_age():
	if Input.is_action_just_pressed("age"):
		#current collision box stops
		get_node("form"+String(age)).set_disabled(true)
		#increment age, go back if 3
		age += 1
		if age == 3:
			age = 0
		#switch collision
		get_node("form"+String(age)).set_disabled(false)
		#switch animation
		$sprite.play("form"+ String(age))
		
		
		
