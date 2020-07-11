extends Spatial

var Area1
var Area2
var Area3
var lap = 0

func _on_Area1_body_entered(body):
	if Area1:
		Area1 = false
		Area2 = true
		Area3 = false
		lap+=1
		if lap == 3:
			get_node("root/MainNode/car/Hud/WinState.tscn").visible = true

func _on_Area2_body_entered(body):
	if Area2:
		Area1 = false
		Area2 = false
		Area3 = true

func _on_Area3_body_entered(body):
	if Area3:
		Area1 = true
		Area2 = false
		Area3 = false
