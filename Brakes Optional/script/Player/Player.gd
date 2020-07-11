extends Node
enum {OFF = 0, ON = 1, WARNING = 2, DANGER = 3}
onready var numPlugs = 6
var thrust = OFF
var brake = OFF
var ignition = OFF
var left = OFF
var fly = OFF
var right = OFF

func _ready():
	deploy_plugs(numPlugs)
	
#this varies depending on the level, makes a variable amount of plugs visible
func deploy_plugs(num):
	var i = 0
	for f in $Hud/plugs.get_children():
		i += 1
		if i <= num:
			f.visible = true
	

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

