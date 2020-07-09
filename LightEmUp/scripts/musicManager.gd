extends Node
enum {FADEOUT, FADEIN}

func _ready():
	get_parent().get_parent().connect("music", self, "chooseMusic")
	get_parent().get_parent().connect("win", self, "endLevel")
#call this when the level changes, but NOT WHEN IT RESETS
#takes the node of the level and plays audio for it
func chooseMusic(level):
	#make sure that the levelEndMusic isn't playing
	var audioFile = "res://audio/levels/Level" + level + ".ogg"
	if File.new().file_exists(audioFile):
		var song = load(audioFile)
		song.set_loop(true)
		$levelMusic.stream = song
		$levelMusic.play()
		fade($levelMusic, 2, FADEIN)
	if $levelEnd/winMusic.is_playing():
		fade($levelEnd/winMusic, 2, FADEOUT)
	elif $title.is_playing():
		fade($title, 2, FADEOUT)
		
#call this when the level is beaten
func endLevel():
	fade($levelMusic, 3, FADEOUT)
	fade($levelEnd/winMusic, 5, FADEIN)
	$levelEnd/jingle.play() 


#activates tween to fade out the song
#FADEOUT or FADEIN
func fade(audioplayer, seconds, fade):
	var t = [0, -80]
	#FADEIN inputted
	if bool(fade):
		t = [-80, 0]
	audioplayer.set_volume_db(t[0])
	var tween = Tween.new()
	add_child(tween)
	tween.interpolate_property(audioplayer, "volume_db", t[0], t[1], seconds, tween.TRANS_LINEAR, tween.EASE_IN, 0)
	tween.start()
	tween.connect("tween_completed", self, "delete_tween", [tween])	
#deletes tweens once they are finished
func delete_tween(audio, _key, tween):
	remove_child(tween)
	tween.queue_free()
	#stop the audio if it's a fadeOut
	if audio.get_volume_db() == -80:
		audio.stop()
	
