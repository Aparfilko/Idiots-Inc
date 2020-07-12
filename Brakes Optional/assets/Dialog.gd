extends PopupDialog
var speech = ["First, hold down the igniter [Shift].",
	"While holding the igniter [Shift], accelerate with [W]!",
	"On these CUTTING-EDGE DEMONS OF SPEED,",
	"The engine pods are designed only to go FAST.",
	"If you go too slow for too long,",
	"the pods will stall, and you will need to restart them!",
	"Activate the main thruster with [W]",
	"Activate the side thrusters with [A] and [D], respectively.",
	"You can try drifting with [Space]!",
	"And use your brakes with [S].",
	"Don't forget your BODACIOUS controls are unplugged!",
	"Drag the power plugs to the controls to activate them.",
	"Try navigating this course to complete your training!"]
var n = 0
var mat = load("res://assets/scene/off.material")
onready var size = get_viewport().size

# Called when the node enters the scene tree for the first time.
func _ready():
	self.pause_mode = PAUSE_MODE_PROCESS
	get_tree().paused = true
	get_tree().get_root().get_node("MainNode/car/Pausenode").halt = true
	$Label.text = speech[n]
	visible = true
	rect_position.x = size[0]/2-300
	rect_size = Vector2(600,250)
func _process(_delta):
	$Label.percent_visible += 0.025
func _input(event):
	if event is InputEventMouseMotion:
		pass
	else:
		if n < speech.size()-1:
			if $Label.percent_visible == 1:
				n += 1
				$Label.text = speech[n]
				$Label.percent_visible = 0
			else:
				$Label.percent_visible = 1
		if n == speech.size()-1 and $Label.percent_visible == 1:
			visible = false
			get_tree().paused = false
			get_tree().get_root().get_node("MainNode/car/Pausenode").halt = false
			self.pause_mode = PAUSE_MODE_STOP
