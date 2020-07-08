extends Node2D


#save level data to the user's computer to keep unlocked levels
func save(content):
	var file = File.new()
	file.open("user://save_game.dat", File.WRITE)
	file.store_string(content)
	file.close()
func load():
	var file = File.new()
	file.open("user://save_game.dat", File.READ)
	var content = file.get_as_text()
	file.close()
	return content

func _ready():
	pass
	
func _physics_process(_delta):
	pass
