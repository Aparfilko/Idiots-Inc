extends AudioStreamPlayer

func _ready():
	get_parent().connect("music", self, "chooseMusic")

#call this when the level changes, but NOT WHEN IT RESETS
#takes the node of the level and plays audio for it
func chooseMusic(level):
	var audioFile = "res://audio/" + level.name + ".ogg"
	if File.new().file_exists(audioFile):
		var song = load(audioFile)
		song.set_loop(true)
		stream = song
		play()
	
