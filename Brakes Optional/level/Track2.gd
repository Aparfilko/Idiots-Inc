extends "res://script/Checkpoints.gd"
onready var plugs = 5
onready var breaking = false
#ign,thrust,lev,left,brake,right
onready var socks = [1,1,1,1,0,1]


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speech = ["Welcome to the RADICAL HYPER MEGA TRACK!",
	"Now that you signed all the waivers,",
	"I can show you the functionality of your SWEET RIDE!",
	"Check her out...",
	"Hop inside and I'll show you how to start the engine pods!"]
var n = 0
var mat = load("res://assets/scene/off.material")
