extends CanvasLayer
onready var holding = false
var mousePos
var curNode
var basePosition
const cursorSpeed = 0.4
var fadeNode
var fadePosition
const fadeSpeed = 0.2
onready var noPick = false
onready var box1Pos = $Select1.get_position()
onready var box1 = false
onready var box2Pos = $Select2.get_position()
onready var box2 = true

#theBoxes
signal returner

func _ready():
	var mouse = InputEventMouseButton.new()
	mouse.set_button_index(1)
	InputMap.add_action("click")
	InputMap.action_add_event("click", mouse)
	

func _process(_dt):
	#make sure mouse position is always updated
	mousePos = get_viewport().get_mouse_position()
	#teleport current holding node to mouse
	if holding and not noPick:
		curNode.set_global_position(lerp(curNode.get_global_position(), mousePos, cursorSpeed))
	#release when mouse is let go
	if Input.is_action_just_released("click") and holding:
		letGo()
		fadeNode = curNode
		fadePosition = basePosition
	#generally just fade back when done
	if is_instance_valid(fadeNode):
		fadeNode.set_position(lerp(fadeNode.get_position(), fadePosition, fadeSpeed))
	
	
func _selectWord(node):
	if not noPick:
		basePosition = node.position
		curNode = node
		holding = true
	
#ok, now you can select stuff
func _resetTimer():
	noPick = false

func letGo():
	holding = false
	noPick = true
	$Timer.start()

func _in_select(_body, box):
	print("yeah")
	box1 = true
func _out_Select1(_body):
	print("")
	box1 = false
func _in_Select2(_body):
	box2 = true
func _out_Select2(_body):
	box2 = false
