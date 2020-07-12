extends Node
signal reset(plugs, breaking, sockets)
var refReplay;
var refCurr;
var refCar;
onready var cnt = 1
onready var resLevel = preload("res://level/Track1.tscn")

func _ready():
	refCar=get_parent().get_node("car");
	connect("reset", refCar, "reset")

func nextOne():
	refCurr=resLevel.instance();
	print(refCurr.name)
	add_child(refCurr);
	refCar.transform=refCurr.get_node("SpawnPoint").transform;
	refReplay.recordStart(cnt);
	
func _on_DeathZone_body_entered(_body):
	emit_signal("reset")
	refCar.transform = refCurr.get_node("SpawnPoint").transform
	
func next_level():
	cnt += 1
	if cnt == 6:
		cnt = 1
		get_node("res://overlay/TitleScreen.tscn").Panel2.visible = true
		get_tree().change_scene("res://overlay/TitleScreen.tscn")
	else:
		remove_child(refCurr)
		refCurr.queue_free()
		resLevel = load("res://level/Track"+String(cnt)+".tscn")
		nextOne()
		emit_signal("reset", refCurr.plugs, refCurr.breaking, refCurr.socks)

func choose_level(i):
	cnt = i
	remove_child(refCurr)
	refCurr.queue_free()
	resLevel = load("res://level/Track"+String(cnt)+".tscn")
	nextOne()
	emit_signal("reset", refCurr.plugs, refCurr.breaking, refCurr.socks)
