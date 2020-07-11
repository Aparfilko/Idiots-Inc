extends Area2D
var curPlug
signal pluggedIn(socket)

func _ready():
	connect("body_entered", self, "readyPlug")
	connect("body_exited", self, "unreadyPlug")
	connect("pluggedIn", get_parent().get_parent(), "get_plug")
	connect("pluggedIn", self, "_activate_time")
	$AnimatedSprite.play("off")
	
func _process(_dt):
	if is_instance_valid(curPlug) and curPlug.plugged == false:
		$AnimatedSprite.play("off")
	
	
	
	
func readyPlug(plug):
	if plug.is_in_group("plug") and not is_instance_valid(curPlug) and not plug.plugged and plug.held:
		plug.hover = true
		plug.pos= get_position() + Vector2(0,9)
		curPlug = plug
		
func unreadyPlug(plug):
	#make sure it's the plug you're using that's unplugging
	if is_instance_valid(curPlug) and plug == curPlug:
		plug.hover = false
		plug.pos = plug.basePos
		curPlug = null
		$AnimatedSprite.play("off")
		

func _input_event(_viewport, _event, _shape_idx):
	if Input.is_action_just_pressed("click") :
		emit_signal("pluggedIn", self)
	elif Input.is_action_just_pressed("unplug") and is_instance_valid(curPlug):
		curPlug.z_index += 1
		curPlug.plugged = false
		curPlug.pos = curPlug.basePos
		curPlug.plugOut()
		curPlug = null
		$AnimatedSprite.play("off")

func _activate_time(_whatever):
	$AnimatedSprite.play("on")
