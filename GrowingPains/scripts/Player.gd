extends KinematicBody2D


const grav = 1000
const accel = 0.5
const bashLength = Vector2(150,0)
signal music(age)
signal killed()
onready var vel = Vector2()
onready var age = 0
onready var speed = [15000, 25000, 10000]
onready var jump = [24000, 32000, 10000]
onready var pins = [Vector2(),Vector2(),Vector2()]

var manager;
func set_manager(m):
	manager=m;

func _ready():
	#bind inputs here
	$bash.set_enabled(true)
	connect("music", get_parent().get_parent(), "update_music")
	get_node("form"+String(age)).set_disabled(false)
	
func _input(event):
	if event.is_action("revert") and Input.is_action_just_pressed("revert"):
		revert()
	elif event.is_action("age") and Input.is_action_just_pressed("age"):
		scan_age()
	elif event.is_action("bash") and Input.is_action_just_pressed("bash") and age == 2:
		attack()

func _physics_process(dt):
	get_movement(dt)
	move_and_slide(vel, Vector2.UP)
	for i in get_slide_count():
		if(get_slide_collision(i)["collider"].get_class()=="Level_Goal"):
			manager.goal_reached();
		if(get_slide_collision(i)["collider"].get_class()=="Enemy"):
			manager.updateLvl();

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
		if is_on_ceiling():
			vel.y = 0
		vel.y += grav * dt
	#bash raycast must face direction player is moving
	if vel.x > 0:
		$bash.set_cast_to(bashLength)
	elif vel.x < 0:
		$bash.set_cast_to(- bashLength)
	

#press revert to teleport to previous pin
func revert():
	set_position(pins[age])
	if age == 0:
		manager.updateLvl();
	else:
		get_node("form"+String(age)).set_disabled(true)
		age -= 1
		get_node("form"+String(age)).set_disabled(false)
		$sprite.play("form"+ String(age))
		emit_signal("music", age + 1)

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
		emit_signal("music", age + 1)
		
#as an old man you can attack
func attack():
	var enemy = $bash.get_collider()
	#if you just attacked an enemy then let them know to be killed
	if is_instance_valid(enemy) and enemy.name.match("Enemy"):
		connect("killed", enemy, "death")
		emit_signal("killed")
		disconnect("killed", enemy, "death")
