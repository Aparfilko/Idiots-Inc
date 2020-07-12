extends AudioStreamPlayer3D
func sound(input, plugged, no):
	if plugged and input and not no:
		self.play()
	else:
		self.stop()

