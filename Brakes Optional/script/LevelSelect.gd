extends Node2D
func _ready():
	resize(Vector2(1920,1080))
func resize(screenInit):
	var x = OS.get_window_size().x/screenInit.x
	var y = OS.get_window_size().y/screenInit.y
	set_scale(Vector2(x, y))

func _on_button_hover():
	$buttonSfx/hover.play()
func _on_button_pressed():
	$buttonSfx/click.play()

func _on_Back_pressed():
	_on_button_pressed()
	get_tree().change_scene("res://overlay/TitleScreen.tscn")

func _on_Track1_pressed():
	_on_button_pressed()
	Global.level = 1
	get_tree().change_scene("res://MainNode.tscn")

func _on_Track2_pressed():
	_on_button_pressed()
	Global.level = 2
	get_tree().change_scene("res://MainNode.tscn")

func _on_Track3_pressed():
	_on_button_pressed()
	Global.level = 3
	get_tree().change_scene("res://MainNode.tscn")
	
func _on_Track4_pressed():
	_on_button_pressed()
	Global.level = 4
	get_tree().change_scene("res://MainNode.tscn")
	
func _on_Track5_pressed():
	_on_button_pressed()
	Global.level = 5
	get_tree().change_scene("res://MainNode.tscn")
