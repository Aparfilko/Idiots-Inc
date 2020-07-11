extends Control
enum {OFF = 0, ON = 1, WARNING = 2, DANGER = 3}
onready var screenInit = Vector2(1920, 1080)
onready var numPlugs = 4
var thrust = OFF
var brake = OFF
var ignition = OFF
var left = OFF
var fly = OFF
var right = OFF

func _ready():
	deploy_plugs(numPlugs)
	resize()


#make sure the hud is sized up to the screen
func resize():
	var s = OS.get_window_size().x/screenInit.x
	set_scale(Vector2(s, 1))
	
#this varies depending on the level, makes a variable amount of plugs visible
func deploy_plugs(num):
	var i = 0
	for f in $plugs.get_children():
		i += 1
		if i <= num:
			f.get_node("AnimatedSprite").play("default")
	

#grabs the thing to activate/make stronger/turn off
func get_plug(name, onOff):
	match name:
		"thrust":
			if onOff and thrust < 3:
				thrust += 1
			elif not onOff:
				thrust = OFF
		"brake":
			if onOff and brake < 3:
				brake += 1
			elif not onOff:
				brake = OFF	
		"ignition":
			if onOff and ignition < 3:
				ignition += 1
			elif not onOff:
				ignition = OFF
		"left":
			if onOff and left < 3:
				left += 1
			elif not onOff:
				left = OFF
		"fly":
			if onOff and fly < 3:
				fly += 1
			elif not onOff:
				fly = OFF
		"right":
			if onOff and right < 3:
				right += 1
			elif not onOff:
				right = OFF



