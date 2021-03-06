extends Node
signal reset(plugs, breaking, sockets)
var refReplay;
var refCurr;
var refCar;
onready var cnt = 1
var resLevel
var onlyNemesis=true;

func _ready():
	print("GLOBALLEVEL: ",Global.level);
	if Global.level>0:
		cnt=Global.level
		onlyNemesis=false;
		Global.level=0
		print("LEVELSELECTED: ",cnt)
	print("ONLYNEMESIS: ",onlyNemesis);
	refCar=get_parent().get_node("car");
	connect("reset", refCar, "reset")
	resLevel = load("res://level/Track"+String(cnt)+".tscn")

func nextOne():
	print("NEXTONE: ",Global.level);
	refCurr=resLevel.instance();
	print(refCurr.name)
	add_child(refCurr);
	refCar.transform=refCurr.get_node("SpawnPoint").transform;
	
func _on_DeathZone_body_entered(_body):
	emit_signal("reset")
	refCar.transform = refCurr.get_node("SpawnPoint").transform
	
func next_level():
	print("NEXTLEVEL: ",Global.level);
	cnt += 1
	if cnt == 6:
		get_tree().change_scene("res://VictoryScreen.tscn")
	else:
		remove_child(refCurr)
		refCurr.queue_free()
		resLevel = load("res://level/Track"+String(cnt)+".tscn")
		nextOne()
		emit_signal("reset", refCurr.plugs, refCurr.breaking, refCurr.socks)
		refReplay.recordStart(cnt,onlyNemesis);

func choose_level(i):
	print("CHOOSELEVEL: ",Global.level);
	cnt = i
	remove_child(refCurr)
	refCurr.queue_free()
	resLevel = load("res://level/Track"+String(cnt)+".tscn")
	nextOne()
	emit_signal("reset", refCurr.plugs, refCurr.breaking, refCurr.socks)
	refReplay.recordStart(cnt,onlyNemesis);
