extends Node

var refOverlay;
var refCurr;
var refCar;
onready var cnt = 1
onready var resLevel = preload("res://level/Track1.tscn")

func _ready():
	refCar=get_parent().get_node("car");
	nextOne()

func nextOne():
	refCurr=resLevel.instance();
	print(refCurr.name)
	add_child(refCurr);
	refCar.transform=refCurr.get_node("SpawnPoint").transform;

func _on_DeathZone_body_entered(body):
	print("welp")
	pass # Replace with function body.
	
func next_level():
	cnt += 1
	remove_child(refCurr)
	refCurr.queue_free()
	resLevel = load("res://level/Track"+String(cnt)+".tscn")
	nextOne()
