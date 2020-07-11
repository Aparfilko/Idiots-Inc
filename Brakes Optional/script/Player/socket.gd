extends Area2D
var curPlug
onready var suck = 5
signal pluggedIn(socket, onOff)
signal goUp(socket, onOff)
onready var i = 0


func _ready():
	var _err
	_err = connect("body_entered", self, "readyPlug")
	_err = connect("body_exited", self, "unreadyPlug")
	_err = connect("pluggedIn", get_parent().get_parent().get_parent(), "get_plug")
	_err = connect("goUp", get_parent().get_parent().get_parent(), "get_plug")
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
	if not curPlug.is_connected("gone", self, "_deactivate"):
		emit_signal("pluggedIn", name, true)
		curPlug.connect("gone", self, "_deactivate")
		$AnimatedSprite.play("on")
		$dangerous.start()
		playSfx("plugs", "plugIn")
	
func _deactivate():
	emit_signal("pluggedIn", name, false)
	curPlug.disconnect("gone", self, "_deactivate")
	$AnimatedSprite.play("off")
	$s.play("default")
	$dangerous.stop()
	playSfx("plugs", "plugOut")
	
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
		emit_signal("goUp", name, true)
		match $AnimatedSprite.get_animation():
			"on":
				$AnimatedSprite.play("warning")
			"warning":
				$AnimatedSprite.play("danger")
				

func playSfx(bus,sfxName):
	var audio = get_node(bus)
	audio.stop()
	audio.stream = load("res://audio/sfx/"+sfxName+".wav")
	audio.play()
