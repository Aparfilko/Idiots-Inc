extends Spatial
signal cakeIn
signal sacrificesIn
var playerBase
var cameraBase

func _ready():
	self.connect("cakeIn",$DeathZone/InCano,"cakeCount")
	self.connect("sacrificesIn",$DeathZone/InCano,"sacrificesCount")
	var playerBase = $"Test Person".position
	var cameraBase = $"Test Person".camera_angle
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

#quit by pressing escape, temp until we have a pause menu
func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().quit()
	if Input.is_action_just_pressed("ui_reset"):		
		get_tree().change_scene("res://Game.tscn")


func _on_DeathZone_body_entered(body):
	if body.name == "Test Person":
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().change_scene("res://ENDSCREN.tscn")
	elif body.name == "cake":
		emit_signal("cakeIn")	
	#change this if we have other objects that can fall in the volcano
	else:
		emit_signal("sacrificesIn")

