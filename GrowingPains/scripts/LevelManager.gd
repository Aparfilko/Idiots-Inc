extends Node2D

onready var lvls=[
	preload("res://levels/Level1.tscn"),
	preload("res://levels/Level2.tscn"),
	preload("res://levels/Level2-1.tscn"),
	preload("res://levels/Level3.tscn"),
	preload("res://levels/Level4.tscn"),
	preload("res://levels/Level5.tscn"),
	preload("res://levels/Level6.tscn"),
	preload("res://levels/Level7.tscn"),
	preload("res://levels/LevelEndScreen.tscn")
	];
onready var a=0;
var currLvl;

func _ready():
	updateLvl();

func updateLvl():
	if(currLvl):
		currLvl.queue_free();
	currLvl=lvls[a].instance();
	currLvl.get_node("Player").set_manager(self);
	add_child(currLvl);
	#start each track from the beginning
	for f in $Music.get_children():
		f.play()
		update_music(1)
		

func goal_reached():
	a+=1;
	updateLvl();

func update_music(ag):
	for i in [1,2,3]:
		if i != ag:
			AudioServer.set_bus_mute(i, true)
		else:
			AudioServer.set_bus_mute(i, false)
