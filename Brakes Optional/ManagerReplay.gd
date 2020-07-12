extends Node

var timer;
var isRecording=false;
var fid;
var userName="DOOTS";
var c;

func _ready():
	timer = Timer.new();
	add_child(timer);
	timer.connect("timeout", self, "meas")
	timer.set_wait_time(1.0)
	timer.set_one_shot(false)

func meas():
	fid.store_float(c.translation[0]);
	fid.store_float(c.translation[1]);
	fid.store_float(c.translation[2]);
	fid.store_float(c.rotation[1]);
	fid.store_8(0);

func recordStart(a):
	fid=File.new();
	fid.open("user://ghost_"+str(a)+"_"+userName+".dat",File.WRITE)
	fid.store_line(userName);
	timer.start();

func recordStop():
	fid.close();
	print("File Written!: ",OS.get_user_data_dir())
	timer.stop();
