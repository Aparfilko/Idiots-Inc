extends Node

var refOverlay;
var refCurr;
var refCar;
onready var resLevel=[
	preload("res://level/Track2.tscn"),
];

func _ready():
	refCar=get_parent().get_node("car");
	refCurr=resLevel[0].instance();
	add_child(refCurr);
	refCar.transform=refCurr.get_node("SpawnPoint").transform;
