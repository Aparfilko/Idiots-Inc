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

#array to run forward or back through levels
#onready var lvls=[
#	preload("res://Levels/Level1.tscn"),
#	preload("res://Levels/Level2.tscn"),
#	preload("res://Levels/Level3.tscn"),
#	preload("res://Levels/Level4.tscn"),
#	preload("res://Levels/Level5.tscn"),
#	preload("res://Levels/Level6.tscn"),
#	preload("res://Levels/Level7.tscn"),
#	preload("res://Levels/LevelEndScreen.tscn")
#	];
#onready var a=0;
#var currLvl;
#
#func _ready():
#	updateLvl();
#
#func updateLvl():
#	if(currLvl):
#		currLvl.queue_free();
#	currLvl=lvls[a].instance();
#	currLvl.get_node("Player").set_manager(self);
#	add_child(currLvl);
#
#func choose_level(i):
#	a=a+i;
#	updateLvl();
