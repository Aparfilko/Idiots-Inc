extends Control

func _ready():
	resize(Vector2(1920,1080))
func resize(screenInit):
	var x = OS.get_window_size().x/screenInit.x
	var y = OS.get_window_size().y/screenInit.y
	set_scale(Vector2(x, y))
