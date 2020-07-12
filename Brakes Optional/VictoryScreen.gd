extends Node2D

func _ready():
	resize(Vector2(1920,1080))
func resize(screenInit):
	var x = OS.get_window_size().x/screenInit.x
	var y = OS.get_window_size().y/screenInit.y
	set_scale(Vector2(x, y))


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		Global.level=0;
		get_tree().change_scene("res://overlay/TitleScreen.tscn")


func _on_Button_pressed():
	$buttonSfx/click.play()
	get_tree().change_scene("res://overlay/TitleScreen.tscn")


func _on_button_hover():
	$buttonSfx/hover.play()
