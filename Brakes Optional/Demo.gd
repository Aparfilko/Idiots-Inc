extends Spatial


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

onready var size = get_viewport().size

# Called when the node enters the scene tree for the first time.
func _ready():
	$Dialog/Label.text = speech[n]
	$Camera.current = true
	$car/body/booster/ass.set_surface_material(0,mat)
	$car/body/booster2/ass.set_surface_material(0,mat)
	$car/body/booster3/ass.set_surface_material(0,mat)
	$Dialog.visible = true
	$Dialog.rect_position.x = size[0]/2-300
	$Dialog.rect_size = Vector2(600,250)
func _process(_delta):
	$car.rotation_degrees.y += 1
	$Dialog/Label.percent_visible += 0.025
func _input(event):
	if event is InputEventMouseMotion:
		pass
	else:
		if n < speech.size()-1:
			if $Dialog/Label.percent_visible == 1:
				n += 1
				$Dialog/Label.text = speech[n]
				$Dialog/Label.percent_visible = 0
			else:
				$Dialog/Label.percent_visible = 1
		if n == speech.size()-1 and $Dialog/Label.percent_visible == 1:
			load("MainNode.tscn")
