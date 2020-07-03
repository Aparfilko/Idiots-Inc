extends Spatial

# Declare member variables here. Examples:
var red = "res://assets/glTF format/RED.material"
var green = "res://assets/glTF format/GREEN.material"
var blue = "res://assets/glTF format/BLUE.material"
var white = "res://assets/glTF format/WHITE.material"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#Let's set the level!
	set("get_child(1).get_child(0).mesh.get_surface_material(0)",green)
	print(get_child(1).get_child(0).mesh.surface_get_material(0))
#func _unhandled_input(_event):
#	if _event is InputEventKey:
#		if _event.pressed and _event.scancode == KEY_SPACE:
#			
#			if $SpotLight.visible == true:
#				$SpotLight.visible = false
#			if $SpotLight.visible == false:
#				$SpotLight.visible = true


func _on_AudioStreamPlayer_finished():
	$AudioStreamPlayer.play()
