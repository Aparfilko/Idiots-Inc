extends KinematicBody2D


const grav = 1000
const accel = 0.5
onready var vel = Vector2()
onready var age = 0
onready var speed = [15000, 25000, 7500] 
onready var jump = [20000, 25000, 10000]
onready var pins = [Vector2(),Vector2(),Vector2()]

var manager;
func set_manager(m):
	manager=m;

func _ready():
	#bind inputs here
	get_node("form"+String(age)).set_disabled(false)
	
func _input(event):
	if event.is_action("revert") and Input.is_action_just_pressed("revert"):
		revert()
	if event.is_action("age") and Input.is_action_just_pressed("age"):
		scan_age()

func _physics_process(dt):
	get_movement(dt)
	move_and_slide(vel, Vector2(0,-1))
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
	if is_on_floor():
		#need this to make movement feel more natural
		if dir * vel.x >= -speed[age] * speed[age] * dt / 100:
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

#press revert to teleport to previous pin
func revert():
	set_position(pins[age])
	if age == 1:
		manager.updateLvl();
	if age != 0:
		get_node("form"+String(age)).set_disabled(true)
		age -= 1
		get_node("form"+String(age)).set_disabled(false)
		$sprite.play("form"+ String(age))

#press age to go to the next form
func scan_age():
	if age != 2:
		#if baby, make sure won't be crushed by turning into teen
		if age == 0 and is_instance_valid($sanity.get_collider()):
			return
		#set current position as pin
		pins[age+1] = get_position()
		#current collision box stops
		get_node("form"+String(age)).set_disabled(true)
		#increment age, go back if 3
		age += 1
		#switch collision
		get_node("form"+String(age)).set_disabled(false)
		#switch animation
		$sprite.play("form"+ String(age))
		
		
		
