extends Node2D

const scl=.1;
const shiftX=(400)*scl;
const shiftY=(1)*scl;
const shiftZ=(400)*scl;

var FLOORTILE;
var TEXTURES;
var floors;
var tileInstance;

var origin;

func _ready():
	FLOORTILE=preload("res://FloorTile.tscn");
	TEXTURES=[
		preload("res://tex/floor1.tres"),
	];
	origin=get_viewport().size/2;
	genLvl("lvl0.txt");

func addBlock(type,pX,pY,pZ):
	var a=FLOORTILE.instance();
	a.scale=Vector2(scl,scl);
	a.position=Vector2(pX*shiftX,pZ*shiftZ);
	a.set_texture(TEXTURES[type]);
	floors[pY].add_child(a);
	tileInstance.append([a,pX,pY,pZ]);

func genLvl(filename):
	floors=[];tileInstance=[];
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
						while(len(floors)<=y):
							floors.append(Node2D.new());
							self.add_child(floors[-1]);
						addBlock(int(a[0]),x,y,z);

func shiftFloors():
	for i in range(len(floors)):
		floors[i].position=self.position*shiftY*i+origin;

func _process(dt):
	if Input.is_action_pressed("ui_left"):
		self.position[0]+=dt*200;
	if Input.is_action_pressed("ui_right"):
		self.position[0]-=dt*200;
	if Input.is_action_pressed("ui_up"):
		self.position[1]+=dt*200;
	if Input.is_action_pressed("ui_down"):
		self.position[1]-=dt*200;
	shiftFloors();
