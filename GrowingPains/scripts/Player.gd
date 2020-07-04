extends KinematicBody2D


const speed = [15000, 30000, 7500] 
const grav = 1000
const accel = 0.3
onready var vel = Vector2()
onready var age = 0
onready var jump = [20000, 25000, 10000]

var manager;
func set_manager(m):
	manager=m;

func _ready():
	#bind inputs here
	get_node("form"+String(age)).set_disabled(false)

func _physics_process(dt):
	scan_age()
	get_movement(dt)
	move_and_slide(vel)
	for i in get_slide_count():
		if(get_slide_collision(i)["collider"].get_class()=="Level_Goal"):
			manager.goal_reached();

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
		
		
		
