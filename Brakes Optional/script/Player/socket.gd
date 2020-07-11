extends Area2D
var curPlug
signal pluggedIn(socket, onOff)

func _ready():
	connect("body_entered", self, "readyPlug")
	connect("body_exited", self, "unreadyPlug")
	connect("pluggedIn", get_parent().get_parent(), "get_plug")
	connect("pluggedOut", get_parent().get_parent(), "get_plug")
	$AnimatedSprite.play("off")
	
	
func readyPlug(plug):
	#has no plugs, and
	if plug.is_in_group("plug") and not is_instance_valid(curPlug) and plug.held:
		plug.connect("read", self, "_activate")
		plug.hover = true
		plug.pos= get_position() + Vector2(0,10)
		curPlug = plug
		$s.play("select")
		
func unreadyPlug(plug):
	#make sure it's the plug you're using that's unplugging
	if is_instance_valid(curPlug) and plug == curPlug:
		curPlug.disconnect("read", self, "_activate")
		plug.hover = false
		plug.pos = plug.basePos
		curPlug = null
		$s.play("default")
		

func _activate():
	emit_signal("pluggedIn", self, true)
	curPlug.connect("gone", self, "_deactivate")
	$AnimatedSprite.play("on")
	
func _deactivate():
	emit_signal("pluggedOut", self, true)
	curPlug.disconnect("gone", self, "_deactivate")
	$AnimatedSprite.play("off")
	$s.play("default")
