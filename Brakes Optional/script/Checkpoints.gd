extends Spatial

onready var Area1 = false
onready var Area2 = false
onready var Area3 = true
var lap = 0

func _on_Area1_body_entered(body):
	if Area1:
		print(lap)
		Area1 = false
		Area2 = true
		Area3 = false
		lap+=1
		print(lap)
		if lap == 3:
			get_node("/root/MainNode/car/Hud/WinState").popup()

func _on_Area2_body_entered(body):
	if Area2:
		print(lap)
		Area1 = false
		Area2 = false
		Area3 = true

func _on_Area3_body_entered(body):
	if Area3:
		print(lap)
		Area1 = true
		Area2 = false
		Area3 = false
