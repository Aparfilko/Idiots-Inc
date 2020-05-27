extends Node2D

const scl=.1;
const shiftFlat=(400);
const shiftUp=(1)*scl;

var TEXTURES;
var GHOSTTEX;
var LIGHTTEX;
var CANBELIT;
var floors;
var walls;

var origin;

func _ready():
	TEXTURES=[
		preload("res://tex/floor0.tres"),
		preload("res://tex/floor1.tres"),
		preload("res://tex/floor2.tres"),
	];
	GHOSTTEX=[
		preload("res://tex/floor0Ghost.tres"),
		preload("res://tex/floor1Ghost.tres"),
		preload("res://tex/floor2Ghost.tres"),
	];
	LIGHTTEX=preload("res://tex/light.tres");
	CANBELIT=preload("res://tex/canBeLit.tres");
	origin=get_viewport().size/2;
	genLvl("lvl0.txt");
	addLight(0,0,0);

func addLight(pX,pY,pZ):
	var a=Light2D.new();
	a.set_texture(LIGHTTEX);
	a.mode=Light2D.MODE_MIX;
	a.shadow_enabled=true;
	a.position=Vector2(pX*shiftFlat*scl,pZ*shiftFlat*scl)
	floors[pY].add_child(a);

func addFloor(type,pX,pY,pZ):
	var a=Sprite.new();
	a.set_texture(GHOSTTEX[type]);
	a.scale=Vector2(scl,scl);
	a.position=Vector2(pX*shiftFlat*scl,pZ*shiftFlat*scl);
	var g=Sprite.new();
	g.set_texture(TEXTURES[type]);
	g.set_material(CANBELIT);
	a.add_child(g);
	floors[pY].add_child(a);

func addWall(type,pX,pY,pZ,o):
	var c=shiftFlat*.5*scl;
	var a=Polygon2D.new();
	a.set_texture(GHOSTTEX[type]);
	var b;
	b=PoolVector2Array();
	b.append(Vector2(-1 if o<5 else 1,-1 if o<3 or o>6 else 1)*c);
	b.append(Vector2(-1 if o<8 and o>3 else 1,-1 if o<6 and o>1 else 1)*c);
	b.append(Vector2(0,0));
	b.append(Vector2(0,0));
	a.set_polygon(b);
	b=PoolVector2Array();
	b.append(Vector2(0,0));
	b.append(Vector2(0,shiftFlat));
	b.append(Vector2(shiftFlat,shiftFlat));
	b.append(Vector2(shiftFlat,0));
	a.set_uv(b);
	a.position=Vector2(pX*shiftFlat*scl,pZ*shiftFlat*scl);
	var g=Polygon2D.new();
	g.set_texture(TEXTURES[type]);
	g.set_material(CANBELIT);
	g.set_polygon(a.get_polygon());
	g.set_uv(a.get_uv());
	a.add_child(g);
	walls[pY].add_child(a);
	var d=LightOccluder2D.new();
	d.occluder=OccluderPolygon2D.new();
	b=PoolVector2Array();
	b.append(Vector2(-1 if o<5 else 1,-1 if o<3 or o>6 else 1)*c);
	b.append(Vector2(-1 if o<8 and o>3 else 1,-1 if o<6 and o>1 else 1)*c);
	d.occluder.set_polygon(b);
	a.add_child(d);
	
	
func genLvl(filename):
	floors=[];walls=[];
	var fid=File.new();
	fid.open("res://lvl/"+filename,File.READ);
	while not fid.eof_reached():
		var currLine=fid.get_line();
		if len(currLine) and currLine[0]!='#':
			var a=currLine.split(" ",true);
			if len(a)<8:
				a.resize(8);
				a[5]=a[2];a[6]=a[3];a[7]=a[4];
			for x in range(int(a[2]),int(a[5])+1):
				for y in range(int(a[3]),int(a[6])+1):
					for z in range(int(a[4]),int(a[7])+1):
						while(len(floors)<=y):
							floors.append(Node2D.new());walls.append(Node2D.new());
							floors[-1].z_index=2*len(floors)-1;walls[-1].z_index=2*len(walls);
							self.add_child(floors[-1]);self.add_child(walls[-1]);
						if int(a[0]):
							addWall(int(a[1]),x,y,z,int(a[0]));
						else:
							addFloor(int(a[1]),x,y,z);

func shiftFloors():
	var s=self.position*shiftUp;
	for i in range(len(floors)):
		floors[i].position=s*i+origin;
		walls[i].position=s*i+origin;
		for w in walls[i].get_children():
			var a=w.get_polygon();
			a.set(2,a[1]+s);
			a.set(3,a[0]+s);
			w.set_polygon(a);
			w.get_child(0).set_polygon(w.get_polygon());

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
