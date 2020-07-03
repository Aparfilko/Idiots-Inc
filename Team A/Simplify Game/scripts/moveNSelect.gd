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
var box
var boxRun
var boxPos
var boxReturn
var basecard = [0, 0]
#theBoxes
signal returner(pos, card)

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
		if is_instance_valid(box):
			#connect("returner", box, "goBack", [curNode.pos, curNode])
			boxPos = box.get_position()
		else:
			fadeNode = curNode
	#generally just fade back when done
	if is_instance_valid(box) and not holding:
		curNode.set_position(lerp(curNode.get_position(), boxPos, fadeSpeed))
	if is_instance_valid(fadeNode):
		fadeNode.set_position(lerp(fadeNode.get_position(), fadeNode.pos, fadeSpeed))
	
	
func _selectWord(node):
	if not noPick:
		curNode = node
		holding = true
	
#ok, now you can select stuff
func _resetTimer():
	noPick = false
	if is_instance_valid(box):
		basecard = [basePosition, curNode]
		emit_signal("returner",basecard)
		box = null

func letGo():
	holding = false
	noPick = true
	$Timer.start()

func _in_Select(_body, node):
	if holding:
		box = node
		print(box)
func _out_Select(_body, _node):
	box = null
	print(box)
#	if not holding
