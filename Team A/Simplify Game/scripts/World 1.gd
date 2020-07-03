extends Spatial

# Declare member variables here. Examples:
onready var red = preload("res://assets/glTF format/RED.material")
onready var green = preload("res://assets/glTF format/GREEN.material")
onready var blue = preload("res://assets/glTF format/BLUE.material")
onready var white = preload("res://assets/glTF format/WHITE.material")

onready var branchy = ["res://assets/BRANCHY", 0.25, -0.011, 0.006]
onready var square = ["res://assets/SQUARE", 0.5, 0.301, -0.291]
onready var circle = ["res://assets/CIRCLE", 1, 0.323, -0.374]

var tall=Vector3(1,1,1)
var short=Vector3(.7,.5,.7)

var thecolors = ["RED","GREEN","BLUE","WHITE"]
var thetypes = ["BRANCHY","SQUARE","CIRCLE"]
var theheights = [.5,1]

# Called when the node enters the scene tree for the first time.
func _ready():
	#Let's set the level!
	changetype(1,tall,circle,red)
	changetype(2,short,square,green)
	changetype(3,tall,square,blue)
	changetype(4,short,branchy,white)
	changetype(5,tall,branchy,green)
	changetype(6,tall,square,red)

func changetype(tree,height,type,color):
	var m = type[1]
	var x = type[2]
	var z = type[3]
	#set mesh
	get_child(tree).get_child(0).mesh = load(str(type[0],tree,".mesh"))
	get_child(tree).get_child(0).scale = Vector3(m,m,m)
	get_child(tree).get_child(0).translation = Vector3(x,0,z)
	#set height
	get_child(tree).scale = height
	get_child(tree).get_child(1).light_energy = 12*height[0]*height[1]*height[2]
	#set color
	get_child(tree).get_child(0).mesh.surface_set_material(0,color)

func _on_AudioStreamPlayer_finished():
	$AudioStreamPlayer.play()

func _process(delta):
	pass
	#if "RED NEEDS TO LIGHT UP":
		#lightItUp(thecolors[0])
	#if "GREEN NEEDS TO LIGHT UP":
		#lightItUp(thecolors[1])
	#if "BLUE NEEDS TO LIGHT UP":
		#lightItUp(thecolors[2])
	#if "WHITE NEEDS TO LIGHT UP":
		#lightItUp(thecolors[3])
	
	#if "SHORT NEEDS TO LIGHT UP":
		#LightTheHeight(theheights[0])
	#if "TALL NEEDS TO LIGHT UP":
		#LightTheHeight(theheights[1])
	
	#if "BRANCHY NEEDS TO LIGHT UP":
		#TypeLight(thetypes[0])
	#if "SQUARE NEEDS TO LIGHT UP":
		#TypeLight(thetypes[1])
	#if "CIRCLE NEEDS TO LIGHT UP":
		#TypeLight(thetypes[2])



func lightItUp(color):
	for treenum in range(1,7):
		if get_child(treenum).get_child(0).mesh.surface_get_material(0).resource_name == color:
			get_child(treenum).get_child(1).visible = true

func LightTheHeight(height):
	for treenum in range(1,7):
		if get_child(treenum).scale.y == height:
			get_child(treenum).get_child(1).visible = true

func TypeLight(type):
	for treenum in range(1,7):
		if get_child(treenum).get_child(0).mesh.resource_name == type:
			get_child(treenum).get_child(1).visible = true
