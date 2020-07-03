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
onready var list = ["nothing", "nothing"]
onready var spots = [0,0,0,0,0,0]
onready var inAnd = true

onready var nexttree = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	#Let's set the level!
	#tree number (1-6)
	#height (tall or short)
	#form (branchy, square, circle)
	#color (red green blue white)
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

#switch between OR rules or AND rules
func _input(_event):
	if Input.is_action_just_pressed("ui_accept"):
		inAnd = not inAnd

func _process(_delta):

	#this part turns off all lights every loop
	if nexttree > 6:
		nexttree = 1
	get_child(nexttree).get_child(1).visible = false
	
	#"RED NEEDS TO LIGHT UP"
	if list[0].match("Card_Red") or list[1].match("Card_Red"):
		lightItUp(thecolors[0])
	if list[0].match("Card_Green") or list[1].match("Card_Green"):
		lightItUp(thecolors[1])
	if list[0].match("Card_Blue") or list[1].match("Card_Blue"):
		lightItUp(thecolors[2])
	if list[0].match("Card_White") or list[1].match("Card_White"):
		lightItUp(thecolors[3])

	if list[0].match("Card_Short") or list[1].match("Card_Short"):
		LightTheHeight(theheights[0])
	if list[0].match("Card_Tall") or list[1].match("Card_Tall"):
		LightTheHeight(theheights[1])

	if list[0].match("Card_Branchy") or list[1].match("Card_Branchy"):
		TypeLight(thetypes[0])
	if list[0].match("Card_Square") or list[1].match("Card_Square"):
		TypeLight(thetypes[1])
	if list[0].match("Card_Round") or list[1].match("Card_Round"):
		TypeLight(thetypes[2])
		
	if (list[0].match("nothing") or list[1].match("nothing")) and inAnd:
		freebie()
		
	spotlights()
	#increments the turn-off loop
	nexttree += 1


func lightItUp(color): #function for turning on spotlights based on color
	for treenum in range(1,7):
		if get_child(treenum).get_child(0).mesh.surface_get_material(0).resource_name == color:
			spots[treenum-1] += 1

func LightTheHeight(height): #function for turning on spotlights based on height
	for treenum in range(1,7):
		if get_child(treenum).scale.y == height:
			spots[treenum-1] += 1

func TypeLight(type): #function for turning on spotlights based on tree type
	for treenum in range(1,7):
		if get_child(treenum).get_child(0).mesh.resource_name == type:
#			get_child(treenum).get_child(1).visible = true
			spots[treenum-1] += 1
			
func freebie():
	for treenum in range(1,7):
		spots[treenum-1] += 1
		
func spotlights():
	for treenum in range(1,7):
		if spots[treenum-1] == 2 and inAnd:
			get_child(treenum).get_child(1).visible = true
		elif spots[treenum-1] >= 1 and not inAnd:
			get_child(treenum).get_child(1).visible = true
		spots[treenum-1] = 0
	
func listCard(card, num, _n, _y):
	list[num] = card.name
	
func deleteCard(num, _n):
	list[num] = "nothing"
