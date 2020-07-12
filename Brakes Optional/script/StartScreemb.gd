extends Panel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var node = preload("res://Demo.tscn").instance()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _ready():
	rect_size = OS.get_window_size()
	$Label.rect_size.x = OS.get_window_size().x
	$Comet.rect_position.x = OS.get_window_size().x /2 - 590
	$VBoxContainer.rect_position.x = OS.get_window_size().x /2 - 220
	$VBoxContainer.rect_position.y = OS.get_window_size().y - 200


#startGame
func _on_start_pressed():
	visible = false
	get_parent().add_child(node)
	
func _on_LevelSelect_pressed():
	get_tree().change_scene("res://overlay/LevelSelect.tscn")

#exit, probably should have a dialog box?
func _on_LeabDisPwace_pressed(): #uwu
	get_tree().quit();
