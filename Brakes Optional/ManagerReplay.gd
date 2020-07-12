extends Node

var refLevel;
var timer;

func _ready():
	pass # Replace with function body.

func _on_Timer_timeout():
	print("Second!")

	timer = Timer.new()
	add_child(timer)

	timer.connect("timeout", self, "meas")
	timer.set_wait_time(1.0)
	timer.set_one_shot(false) # Make sure it loops
	timer.start()
