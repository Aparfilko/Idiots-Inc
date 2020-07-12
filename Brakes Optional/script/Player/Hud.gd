extends Control
enum {OFF = 0, ON = 1, WARNING = 2, DANGER = 3}
onready var screenInit = Vector2(1920, 1080)
onready var numPlugs = 4
#ign,thrust,lev,left,brake,right
onready var socks = [OFF,OFF,OFF,OFF,OFF,OFF]

func _ready():
	deploy_plugs(numPlugs)
	resize()

#make sure the hud is sized up to the screen
func resize():
	var x = OS.get_window_size().x/screenInit.x
	var y = OS.get_window_size().y/screenInit.y
	set_scale(Vector2(x, y))
	
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
		"ignition":
			if onOff and socks[0] < 3:
				socks[0] += 1
			elif not onOff:
				socks[0] = OFF
		"thrust":
			if onOff and socks[1] < 3:
				socks[1] += 1
			elif not onOff:
				socks[1] = OFF
		"fly":
			if onOff and socks[2] < 3:
				socks[2] += 1
			elif not onOff:
				socks[2] = OFF
		"left":
			if onOff and socks[3] < 3:
				socks[3] += 1
			elif not onOff:
				socks[3] = OFF
		"brake":
			if onOff and socks[4] < 3:
				socks[4] += 1
			elif not onOff:
				socks[4] = OFF	
		"right":
			if onOff and socks[5] < 3:
				socks[5] += 1
			elif not onOff:
				socks[5] = OFF

#get the speed and display it on the dashboard
func mph(speed):
	speed = int(abs(speed))
	if speed < 10:
		$mph/Label.text = "00"+String(speed)
	elif speed < 100:
		$mph/Label.text = "0"+String(speed)
	elif speed < 1000:
		$mph/Label.text = String(speed)
	else:
		$mph/Label.text = "999"

#get the rotation and turn the wheel that much MUST BE IN RAD
func wheel(rot):
	$wheel.rotation = rot
