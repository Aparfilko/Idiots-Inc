extends Node
signal reset(plugs, breaking, sockets)
var refReplay;
var refCurr;
var refCar;
onready var cnt = 1
var resLevel
var onlyNemesis=1;

func _ready():
	if Global.level>0:
		cnt=Global.level
		onlyNemesis=0;
		Global.level=0
	refCar=get_parent().get_node("car");
	connect("reset", refCar, "reset")
	resLevel = load("res://level/Track"+String(cnt)+".tscn")

func nextOne():
	refCurr=resLevel.instance();
	print(refCurr.name)
	add_child(refCurr);
	refCar.transform=refCurr.get_node("SpawnPoint").transform;
	
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
		refReplay.recordStart(cnt,onlyNemesis);

func choose_level(i):
	cnt = i
	remove_child(refCurr)
	refCurr.queue_free()
	resLevel = load("res://level/Track"+String(cnt)+".tscn")
	nextOne()
	emit_signal("reset", refCurr.plugs, refCurr.breaking, refCurr.socks)
	refReplay.recordStart(cnt,onlyNemesis);
