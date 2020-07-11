extends Control
var screenInit = Vector2(1920, 1080)
var numPlugs = 6

func _ready():
	resize()


#make sure the hud is sized up to the screen
func resize():
	var s = OS.get_window_size().x/screenInit.x
	set_scale(Vector2(s, 1))
	

func _process(delta):
	pass

func get_plug(name):
	pass
