extends Control
enum {OFF = 0, ON = 1, WARNING = 2, DANGER = 3}
onready var screenInit = Vector2(1920, 1080)
onready var numPlugs = 6
onready var breaky = false
#ign,thrust,lev,left,brake,right
onready var socks = [0,0,0,0,0,0]

func _ready():
	print("fuck this bus: " + String(AudioServer.get_bus_index("sfx")))
	resize()
	AudioServer.set_bus_mute(2, true)
	set_up(numPlugs, breaky, socks)


func set_up(num, isBreaking, sockets):
	AudioServer.set_bus_mute(2, true)
	deploy_plugs(num, isBreaking)
	supply_sockets(sockets)
	AudioServer.set_bus_mute(2, false)
	
#make sure the hud is sized up to the screen
func resize():
	var x = OS.get_window_size().x/screenInit.x
	var y = OS.get_window_size().y/screenInit.y
	set_scale(Vector2(x, y))
	
#this varies depending on the level, makes a variable amount of plugs visible
func deploy_plugs(num, isBreaking):
	var i = 0
	for f in $plugs.get_children():
		i += 1
		if i <= num:
			f.get_node("AnimatedSprite").play("default")
	breaky = isBreaking
	
func supply_sockets(socks):
	#check all sockets
	var i = -1
	for s in $sockets.get_children():
		print(s.name)
		i += 1
		if socks[i] > OFF and not is_instance_valid(s.curPlug):
			for p in $plugs.get_children():
				if p.plugged:
					continue
				else:
					p.held = true
					s.readyPlug(p)
					p.plugIn()
					print(s.name + "is used")
					break
			print("done!")

#grabs the thing to activate/make stronger/turn off
func get_plug(name, onOff):
	match name:
		"ignition":
			if onOff:
				if not breaky:
					socks[0] = 1
				elif socks[0] < 3:
					socks[0] += 1
			elif not onOff:
				socks[0] = OFF
		"thrust":
			if onOff:
				if not breaky:
					socks[1] = 1
				elif socks[1] < 3:
					socks[1] += 1
			elif not onOff:
				socks[1] = OFF
		"fly":
			if onOff:
				if not breaky:
					socks[2] = 1
				elif socks[2] < 3:
					socks[2] += 1
			elif not onOff:
				socks[2] = OFF
		"left":
			if onOff:
				if not breaky:
					socks[3] = 1
				elif socks[3] < 3:
					socks[3] += 1
			elif not onOff:
				socks[3] = OFF
		"brake":
			if onOff:
				if not breaky:
					socks[4] = 1
				elif socks[4] < 3:
					socks[4] += 1
			elif not onOff:
				socks[4] = OFF	
		"right":
			if onOff:
				if not breaky:
					socks[5] = 1
				elif socks[5] < 3:
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
