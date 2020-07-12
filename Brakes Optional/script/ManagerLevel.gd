extends Node

var refOverlay;
var refCurr;
var refCar;
onready var resLevel=[
	preload("res://level/TestTrack.tscn"),
	preload("res://level/Track1.tscn"),
	preload("res://level/Track2.tscn"),
	preload("res://level/Track3.tscn"),
];

func _ready():
	refCar=get_parent().get_node("car");
	refCurr=resLevel[0].instance();
	add_child(refCurr);
	refCar.transform=refCurr.get_node("SpawnPoint").transform;
	get_parent().get_node("car").get_node("Hud").get_node("WinState").set_ManagerLevel(self)
