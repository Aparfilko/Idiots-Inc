extends Panel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

#startGame
func _on_start_pressed():
	get_tree().change_scene("res://Demo.tscn")


#exit, probably should have a dialog box?
func _on_LeabDisPwace_pressed(): #uwu
	get_tree().quit();


func _on_credits_pressed():
	get_tree().change_scene("res://Credits Page.tscn")
