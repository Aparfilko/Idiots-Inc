extends "res://script/Checkpoints.gd"
onready var plugs = 6
onready var breaking = false
#ign,thrust,lev,left,brake,right
onready var socks = [1,1,1,1,1,1]
var speech = ["Welcome to the RADICAL HYPER MEGA TRACK!",
	"Now that you signed all the waivers...",
	"I can show you the functionality of your SWEET RIDE.",
	"Check her out...",
	"Hop inside and I'll show you how to start the engine pods!",
	"First, hold down the igniter [Shift].",
	"While holding the igniter [Shift], accelerate with [W]!",
	"On these CUTTING-EDGE DEMONS OF SPEED,",
	"The engine pods are designed only to go FAST.",
	"If you go too slow for too long,",
	"the pods will stall, and you will need to restart them!",
	"Activate the Main thruster with [W]",
	"Activate the side thrusters with [A] and [D], respectively.",
	"You can try drifting with [Space]!",
	"And lastly, slow down with [S].",
	"Try navigating this course to complete your training!"]
var n = 0
var mat = load("res://assets/scene/off.material")
