extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var spot = Vector3(1,0,0)
var spotback = Vector3(-4,0,0)
var count = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _unhandled_input(_event):
	if _event is InputEventKey:
		if _event.pressed and _event.scancode == KEY_SPACE:
			$SpotLight.visible = true
			count += 1
			$SpotLight.translate(spot)
			if count > 2:
				$SpotLight.translate(spotback)
				count=-1
