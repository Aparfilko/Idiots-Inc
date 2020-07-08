extends Control
enum {NOTHING = -1, ALLLAMP = 1,DOWNLAMP = 2, LEFTLAMP = 3, UPLAMP = 4, RIGHTLAMP = 5, DELETE = 6, PLACE = 10}
signal pass_choice(choice)
var c

func _ready():
	connect("pass_choice", get_parent().get_parent().get_node("Obs"), "get_choice")

#hotkeys
func _input(event):
	#press spacebar to cancel selection
	if event.is_action("ui_select") and Input.is_action_just_pressed("ui_select"):
		express_choice(NOTHING)
	#1
	if event.is_action("alllamp") and Input.is_action_just_pressed("alllamp"):
		express_choice(ALLLAMP)
	#2
	if event.is_action("downlamp") and Input.is_action_just_pressed("downlamp"):
		express_choice(DOWNLAMP)
	#3
	if event.is_action("uplamp") and Input.is_action_just_pressed("uplamp"):
		express_choice(UPLAMP)
	#4
	if event.is_action("leftlamp") and Input.is_action_just_pressed("leftlamp"):
		express_choice(LEFTLAMP)
	#5
	if event.is_action("rightlamp") and Input.is_action_just_pressed("rightlamp"):
		express_choice(RIGHTLAMP)
	#left click to place
	if event.is_action("place") and Input.is_action_just_pressed("place"):
		express_choice(PLACE)
	#right click to activate delete mode
	if event.is_action("delete") and Input.is_action_just_pressed("delete"):
		express_choice(DELETE)
func express_choice(tile):
	emit_signal("pass_choice", tile)

func _cancelDelete():
	if $toolbar/cancelDelete.text.match("delete"):
		$toolbar/cancelDelete.text = "cancel"
		c = DELETE
		express_choice(c)
	else:
		$toolbar/cancelDelete.text = "delete"
		if c == DELETE:
			express_choice(c)
		else:
			express_choice(NOTHING)
		c = NOTHING

func _activateLamp(lamp):
	c = lamp
	express_choice(c)
	$toolbar/cancelDelete.text = "cancel"

