extends Control
enum {OFF = 0, ON = 1, WARNING = 2, DANGER = 3}
onready var screenInit = Vector2(1920, 1080)

func _ready():
	resize()
	pass


#make sure the hud is sized up to the screen
func resize():
	var s = OS.get_window_size().x/screenInit.x
	set_scale(Vector2(s, 1))
	
	

