extends AudioStreamPlayer3D
func sound(input, plugged):
	if (input and plugged) and not self.is_playing():
		self.play()
	elif not (input and plugged):
		self.stop()

