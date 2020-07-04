extends Node2D

onready var lvls=[
	preload("res://levels/Level1.tscn"),
	preload("res://levels/Level2.tscn"),
	preload("res://levels/Level3.tscn"),
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

func goal_reached():
	a+=1;
	updateLvl();
