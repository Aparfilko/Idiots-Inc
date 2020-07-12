extends PopupDialog
var speech = [
	"Before starting, remember to connect up all your controls.",
	"Before you can race away with the [W] [A] [S] [D] keys...",
	"You must first start the thruster with the Ignition [Shift]",
	"The Ignition allows you to accelerate while at low speeds.",
	"Don't forget: your BODACIOUS controls are unplugged!",
	"Drag the power plugs to the controls to activate them.",
	"Run 3 laps to complete your training!"]
var n = 0
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
	$speaker.texture = preload("res://img/Dave.png")
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
