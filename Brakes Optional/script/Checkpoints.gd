extends Spatial
enum {NEXT1, NEXT2, NEXT3}
var goals = NEXT2
var lap = 0

func _on_Area1_body_entered(_body):
	if goals == NEXT1:
		goals = NEXT2
		lap+=1
		if lap == 3:
			get_tree().get_root().get_node("MainNode/car/Pausenode").halt = true
			get_tree().get_root().get_node("MainNode/car/WinState/AudioStreamPlayer").play()
			get_tree().paused = true
			get_tree().get_root().get_node("MainNode/car/WinState").popup_centered()
			get_tree().get_root().get_node("MainNode/ManagerReplay").recordStop();


func _on_Area2_body_entered(_body):
	if goals == NEXT2:
		goals = NEXT3

func _on_Area3_body_entered(_body):
	if goals == NEXT3:
		goals = NEXT1
