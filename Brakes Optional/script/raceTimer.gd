extends Control

onready var screenInit = Vector2(1920, 1080)

func _ready():
	resize()
	setTime(0);
	
func resize():
	var x = OS.get_window_size().x/screenInit.x
	var y = OS.get_window_size().y/screenInit.y
	set_scale(Vector2(x, y))
	
func setTime(a):
	$ColorRect/time.text=str(a);
