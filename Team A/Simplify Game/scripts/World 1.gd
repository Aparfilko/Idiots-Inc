extends Spatial

# Declare member variables here. Examples:
onready var red = preload("res://assets/glTF format/RED.material")
onready var green = preload("res://assets/glTF format/GREEN.material")
onready var blue = preload("res://assets/glTF format/BLUE.material")
onready var white = preload("res://assets/glTF format/WHITE.material")

var branchy = [preload("res://assets/BRANCHY.mesh"), 0.25, -0.011, 0.006]
var square = [preload("res://assets/SQUARE.mesh"), 0.5, 0.293, 0.5]
var circle = [preload("res://assets/CIRCLE.mesh"), 1, 0.323, -0.374]

var tall=Vector3(1,1,1)
var short=Vector3(.7,.5,.7)
# Called when the node enters the scene tree for the first time.
func _ready():
	#Let's set the level!
	changetype(1,tall,square,red)
	changetype(2,short,square,green)
	changetype(3,tall,square,blue)
	changetype(4,short,square,white)
	changetype(5,tall,square,green)
	changetype(6,tall,square,green)
	print(get_child(1).get_child(0).mesh.surface_get_material(0))

func changetype(tree,height,type,color):
	var m = type[1]
	var x = type[2]
	var z = type[3]
	#set mesh
	get_child(tree).get_child(0).mesh = type[0]
	get_child(tree).get_child(0).scale = Vector3(m,m,m)
	get_child(tree).get_child(0).translation = Vector3(x,0,z)
	#set height
	get_child(tree).scale = height
	#set color
	get_child(tree).get_child(0).mesh.surface_set_material(0,color)

func _on_AudioStreamPlayer_finished():
	$AudioStreamPlayer.play()
