extends Area2D
var curPlug
onready var suck = 10
signal pluggedIn(socket, onOff)
signal goUp(socket, onOff)
onready var i = 0


func _ready():
	var _err
	_err = connect("body_entered", self, "readyPlug")
	_err = connect("body_exited", self, "unreadyPlug")
	_err = connect("pluggedIn", get_parent().get_parent(), "get_plug")
	_err = connect("goUp", get_parent().get_parent(), "get_plug")
	$AnimatedSprite.play("off")
	create_timer(suck)
	
	
func readyPlug(plug):
	#has no plugs, and plug is held
	if plug.is_in_group("plug") and not is_instance_valid(curPlug) and plug.held:
		#deactivate the last socket if it wasn't already
#		if is_instance_valid(plug.lastOver) and plug.lastOver != self:
#			plug.lastOver.semiUnready(plug)
		plug.connect("read", self, "_activate")
		#this exists to fix a nasty bug with plugs not unpriming in the proper order
		plug.hover = true
		plug.pos= get_position() + Vector2(-17,-19)
		curPlug = plug
		$s.play("select")
#		print(name + " is primed")
		
func unreadyPlug(plug):
	#make sure it's the plug you're using that's unplugging
	if is_instance_valid(curPlug) and plug == curPlug:
		plug.disconnect("read", self, "_activate")
		plug.hover = false
#		plug.pos = plug.basePos
		curPlug = null
		$s.play("default")
		#oh, there's another node you're still in, activate that
#		if is_instance_valid(plug.secondOver): 
#			plug.secondOver.readyPlug(plug)
#		print(name + " is unprimed")


func _activate():
	if not curPlug.is_connected("gone", self, "_deactivate"):
		emit_signal("pluggedIn", name, true)
		curPlug.connect("gone", self, "_deactivate")
		$AnimatedSprite.play("on")
		$dangerous.start()
		playSfx("plugs", "plugIn")
#		print(name + " is activated")
	
func _deactivate():
	emit_signal("pluggedIn", name, false)
	curPlug.disconnect("gone", self, "_deactivate")
	$AnimatedSprite.play("off")
	$dangerous.stop()
	$warnings.stop()
	playSfx("plugs", "plugOut")
#	print(name + " is deactivated")
	
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
				playSfx("warnings", "warning")
			"warning":
				$AnimatedSprite.play("danger")
				playSfx("warnings", "danger")
				

func playSfx(bus,sfxName):
	var audio = get_node(bus)
	audio.stop()
	audio.stream = load("res://audio/sfx/"+sfxName+".wav")
	audio.play()
