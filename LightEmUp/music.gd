extends AudioStreamPlayer
var target
var speed

func _ready():
	pass # Replace with function body.
	
#fades in the song in the given amount of seconds
func fade_in(seconds):
	set_volume_db(-80)
	target = 0
	speed = seconds
	play()
	
func fade_out(seconds):
	target = -80
	speed = seconds
	
func _process(dt):
	pass
