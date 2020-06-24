extends Spatial
var playerBase
var cameraBase

func _ready():
	var playerBase = $"Test Person".position
	var cameraBase = $"Test Person".camera_angle
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _on_DeathZone_body_entered(body):
	if body.name == "Test Person":
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().change_scene("res://ENDSCREN.tscn")



