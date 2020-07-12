extends Node

var refOverlay;
var refCurr;
var refCar;
onready var resLevel=[
#	preload("res://level/TestTrack.tscn"),
	preload("res://level/Track1.tscn"),
#	preload("res://level/Track2.tscn"),
#	preload("res://level/Track3.tscn"),
];

func _ready():
	refCar=get_parent().get_node("car");
	refCurr=resLevel[0].instance();
	add_child(refCurr);
	refCar.transform=refCurr.get_node("SpawnPoint").transform;

func _on_DeathZone_body_entered(_body):
	pass # Replace with function body.
