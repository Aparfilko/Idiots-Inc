extends Area2D
var curPlug
onready var suck = 5
signal pluggedIn(socket, onOff)


func _ready():
	connect("body_entered", self, "readyPlug")
	connect("body_exited", self, "unreadyPlug")
	connect("pluggedIn", get_parent().get_parent().get_parent(), "get_plug")
	$AnimatedSprite.play("off")
	create_timer(suck)
	
	
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
	emit_signal("pluggedIn", name, true)
	curPlug.connect("gone", self, "_deactivate")
	$AnimatedSprite.play("on")
	$dangerous.start()
	
func _deactivate():
	emit_signal("pluggedIn", name, false)
	curPlug.disconnect("gone", self, "_deactivate")
	$AnimatedSprite.play("off")
	$s.play("default")
	$dangerous.stop()
	
func create_timer(time):
	var t = Timer.new()
	add_child(t)
	t.wait_time = time
	t.one_shot = true
	t.name = "dangerous"
	t.connect("timeout", self, "increase_danger")
	
func increase_danger():
	if not ($AnimatedSprite.get_animation().match("off") or $AnimatedSprite.get_animation().match("danger")):
		$dangerous.start()
		emit_signal("pluggedIn", name, true)
		match $AnimatedSprite.get_animation():
			"on":
				$AnimatedSprite.play("warning")
			"warning":
				$AnimatedSprite.play("danger")
