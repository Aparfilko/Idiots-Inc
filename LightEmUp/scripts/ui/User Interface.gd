extends Control
enum {NOTHING = -1, ALLLAMP = 1,DOWNLAMP = 2, LEFTLAMP = 3, UPLAMP = 4, RIGHTLAMP = 5, DELETE = 6, PLACE = 10}
signal pass_choice(choice)
var c
signal resize()

func _ready():
	connect("pass_choice", get_parent().get_parent().get_node("Obs"), "get_choice")
	get_tree().get_root().connect("size_changed", self, "resize")
	resize()

#hotkeys
func _input(event):
	#press spacebar to cancel selection
	#1
	if event.is_action("alllamp") and Input.is_action_just_pressed("alllamp"):
		_activateLamp(ALLLAMP)
	#2
	if event.is_action("downlamp") and Input.is_action_just_pressed("downlamp"):
		_activateLamp(DOWNLAMP)
	#3
	if event.is_action("uplamp") and Input.is_action_just_pressed("uplamp"):
		_activateLamp(UPLAMP)
	#4
	if event.is_action("leftlamp") and Input.is_action_just_pressed("leftlamp"):
		_activateLamp(LEFTLAMP)
	#5
	if event.is_action("rightlamp") and Input.is_action_just_pressed("rightlamp"):
		_activateLamp(RIGHTLAMP)
	#left click to place
	if event.is_action("place") and Input.is_action_just_pressed("place"):
		express_choice(PLACE)
	#right click to activate delete mode
	if event.is_action("delete") and Input.is_action_just_pressed("delete"):
		express_choice(DELETE)
		
func express_choice(tile):
	emit_signal("pass_choice", tile)


func _activateLamp(lamp):
	print(lamp)
	lamp = int(lamp)
	c = lamp
	express_choice(c)
		
func resize():
	var size = get_viewport_rect().size * get_parent().get_zoom()
	rect_position = -size/2
	rect_size = size
	$toolbar.rect_position.y = size.y - 100
	emit_signal("resize")
