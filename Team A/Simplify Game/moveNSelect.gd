extends CanvasLayer
onready var holding = false
var mousePos
var curNode
var basePosition
var fadeNode
var fadePosition
const fadeSpeed = 0.2

onready var noPick = false

func _ready():
	pass # Replace with function body.
	

func _process(_dt):
	#make sure mouse position is always updated
	mousePos = get_viewport().get_mouse_position()
	#teleport current holding node to mouse
	if holding and not noPick:
		curNode.set_global_position(mousePos)
	#release when mouse is let go
	if Input.is_action_just_released("click"):
		holding = false
		noPick = true
		fadeNode = curNode
		fadePosition = basePosition
		
		$Timer.start()
	#generally just fade back when done
	if is_instance_valid(fadeNode):
		fadeNode.set_position(lerp(fadeNode.get_position(), fadePosition, fadeSpeed))
	
	
func _selectWord(node):
	basePosition = node.position
	curNode = node
	holding = true
	


#ok, now you can select stuff
func _resetTimer():
	noPick = false


