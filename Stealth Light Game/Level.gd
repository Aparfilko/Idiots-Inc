extends Node2D

const scl=.1;
const shiftX=Vector2(265,110)*scl;
const shiftY=Vector2(0,-145)*scl;
const shiftZ=Vector2(-120,220)*scl;

var origin=Vector2(200,200);
var blockTemplate=[];
var blockInstance=[];
func _ready():
	blockTemplate.append(preload("res://BlockBase.tscn"));
	genLvl("lvl0.txt");
	
func addBlock(type,pX,pY,pZ):
	var a=blockTemplate[type].instance();
	a.scale=Vector2(scl,scl);
	self.add_child(a);
	blockInstance.append([a,pX,pY,pZ]);

func genLvl(filename):
	var fid=File.new();
	fid.open("res://lvl/"+filename,File.READ);
	while not fid.eof_reached():
		var currLine=fid.get_line();
		if len(currLine) and currLine[0]!='#':
			var a=currLine.split(" ",true);
			if len(a)<7:
				a.resize(7);
				a[4]=a[1];a[5]=a[2];a[6]=a[3];
			for x in range(int(a[1]),int(a[4])+1):
				for y in range(int(a[2]),int(a[5])+1):
					for z in range(int(a[3]),int(a[6])+1):
						addBlock(int(a[0]),x,y,z);
	blockInstance.sort_custom(self,"sortBlock");
	for i in range(len(blockInstance)):
		#only 10 dudes can stand on a single tile before they start glitching
		blockInstance[i][0].z_index=i;
	updateBlockPos();

func sortBlock(a,b):
	if a[2]!=b[2]:
		return a[2]<b[2];
	if a[3]!=b[3]:
		return a[3]<b[3];
	return a[1]<b[1];

func updateBlockPos():
	for a in blockInstance:
		a[0].position=shiftX*a[1]+shiftY*a[2]+shiftZ*a[3]+origin;

func _process(dt):
	if Input.is_action_pressed("ui_left"):
		origin[0]+=dt*100;
	if Input.is_action_pressed("ui_right"):
		origin[0]-=dt*100;
	if Input.is_action_pressed("ui_up"):
		origin[1]+=dt*100;
	if Input.is_action_pressed("ui_down"):
		origin[1]-=dt*100;
	updateBlockPos();
