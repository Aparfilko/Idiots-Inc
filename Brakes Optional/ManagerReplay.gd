extends Node

var timer;
var isRecording=false;
var fid;
var userName="PLAYER";
var c;
onready var refGhost=preload("res://assets/scene/ghost.tscn");

func _ready():
	timer = Timer.new();
	add_child(timer);
	timer.connect("timeout", self, "meas")
	timer.set_wait_time(.5)
	timer.set_one_shot(false)

func meas():
	fid.store_float(c.translation[0]);
	fid.store_float(c.translation[1]);
	fid.store_float(c.translation[2]);
	fid.store_float(c.rotation[1]);
	fid.store_8(
		(4 if c.isBooster[0] else 0) +
		(2 if c.isBooster[1] else 0) +
		(1 if c.isBooster[2] else 0)
	);

func initGhosts(a):
	var dir=Directory.new();
	dir.open("res://ghost/");
	dir.list_dir_begin();
	while true:
		var file=dir.get_next();
		if file=="":
			break;
		if file.begins_with("ghost_"+str(a)):
			var f=File.new();
			f.open("res://ghost/"+file,File.READ);
			if f.get_line()[0]=="1":
				var g=refGhost.instance();
				g.scale=c.scale;
				g.gName=f.get_line();
				while not f.eof_reached():
					g.arrTranslation.append(Vector3(f.get_float(),f.get_float(),f.get_float()));
					g.arrRotation.append(f.get_float());
					var b=f.get_8();
					g.arrBoost.append([b>=4,b%4>=2,b%2>=1])
				f.close();
				g.t=0;
				add_child(g);
	dir.list_dir_end();

func recordStart(a):
	initGhosts(a);
	fid=File.new();
	fid.open("res://ghost/ghost_"+str(a)+"_"+userName+".dat",File.WRITE)
	fid.store_line("0");
	fid.store_line(userName);
	timer.start();
	meas();

func recordStop():
	fid.seek(0);
	fid.store_line("1");
	fid.close();
	print("File Written!: ",OS.get_user_data_dir())
	timer.stop();

