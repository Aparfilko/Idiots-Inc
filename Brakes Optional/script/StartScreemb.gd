extends Panel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var node = preload("res://Demo.tscn").instance()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

#startGame
func _on_start_pressed():
	visible = false
	get_parent().add_child(node)


#exit, probably should have a dialog box?
func _on_LeabDisPwace_pressed(): #uwu
	get_tree().quit();



