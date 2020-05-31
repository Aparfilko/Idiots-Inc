extends Node2D

const sclFlat=.1;
const sclUp=1.1;
const shiftFlat=400;
const shiftSpeed = 200;

var TEXTURES;
var GHOSTTEX;
var LIGHTTEX;
var CANBELIT;
var floors;
var walls;
var impulse;
var initPlayer;

var EnemyMovementNodes;

var lightTemp;
var lightTempT1=0;
var lightTempT2=0;
var lightTempV1=0;
var lightTempV2=0;

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
	self.position=get_viewport().size/2;
	initPlayer = self.position
	genLvl("Real_Level.txt");

	print(EnemyMovementNodes);
	addLight(-7,0,-8);

func addLight(pX,pY,pZ):
	var a=Light2D.new();
	a.set_texture(LIGHTTEX);
	a.mode=Light2D.MODE_MIX;
	a.shadow_enabled=true;
	a.position=Vector2(pX*shiftFlat*sclFlat,pZ*shiftFlat*sclFlat)
	a.scale=Vector2(1,1)/sclFlat;
	floors[pY].add_child(a);
	lightTemp=a;

func addFloor(type,pX,pY,pZ):
	var a=Sprite.new();
	a.set_texture(GHOSTTEX[type]);
	a.position=Vector2(pX,pZ)*shiftFlat;
	var g=Sprite.new();
	g.set_texture(TEXTURES[type]);
	g.set_material(CANBELIT);
	a.add_child(g);
	floors[pY].add_child(a);

func addWall(type,pX,pY,pZ,o):
	var v0=Vector2(-1 if o<5 else 1,-1 if o<3 or o>6 else 1)*shiftFlat*.5;
	var v1=Vector2(-1 if o<8 and o>3 else 1,-1 if o<6 and o>1 else 1)*shiftFlat*.5;
	var p=StaticBody2D.new();
	p.position=Vector2(pX,pZ)*shiftFlat;
	
	var a=Polygon2D.new();
	a.set_texture(GHOSTTEX[type]);
	var b;
	b=PoolVector2Array();
	b.append(v0);
	b.append(v1);
	b.append(Vector2(0,0));
	b.append(Vector2(0,0));
	a.set_polygon(b);
	b=PoolVector2Array();
	b.append(Vector2(0,0)*shiftFlat);
	b.append(Vector2(0,1)*shiftFlat);
	b.append(Vector2(1,1)*shiftFlat);
	b.append(Vector2(1,0)*shiftFlat);
	a.set_uv(b);
	p.add_child(a);
	
	var g=Polygon2D.new();
	g.set_texture(TEXTURES[type]);
	g.set_material(CANBELIT);
	g.set_polygon(a.get_polygon());
	g.set_uv(a.get_uv());
	p.add_child(g);
	
	var c=CollisionShape2D.new();
	c.shape=SegmentShape2D.new();
	c.shape.a=v0;
	c.shape.b=v1;
	p.add_child(c);
	
	var d=LightOccluder2D.new();
	d.occluder=OccluderPolygon2D.new();
	b=PoolVector2Array();
	b.append(v0);
	b.append(v1);
	d.occluder.set_polygon(b);
	p.add_child(d);
	
	walls[pY].add_child(p);
	
	
func genLvl(filename):
	floors=[];walls=[];
	EnemyMovementNodes=[];
	var fid=File.new();
	fid.open("res://lvl/"+filename,File.READ);
	while not fid.eof_reached():
		var currLine=fid.get_line();
		if len(currLine) and currLine[0]!='#':
			var a=currLine.split(" ",true);
			if int(a[0])<0:
				EnemyMovementNodes.append([]);
				for i in range(1,len(a)):
					EnemyMovementNodes[-1].append(int(a[i]));
				continue;
			if len(a)<8:
				a.resize(8);
				a[5]=a[2];a[6]=a[3];a[7]=a[4];
			for x in range(int(a[2]),int(a[5])+1):
				for y in range(int(a[3]),int(a[6])+1):
					for z in range(int(a[4]),int(a[7])+1):
						while(len(floors)<=y):
							floors.append(Node2D.new());walls.append(Node2D.new());
							floors[-1].z_index=2*len(floors)-1;walls[-1].z_index=2*len(walls);
							floors[-1].scale=Vector2(1,1)*sclFlat*pow(sclUp,len(floors)-1);
							walls[-1].scale=Vector2(1,1)*sclFlat*pow(sclUp,len(floors)-1);
							self.add_child(floors[-1]);self.add_child(walls[-1]);
						if int(a[0])>0:
							addWall(int(a[1]),x,y,z,int(a[0]));
						else:
							addFloor(int(a[1]),x,y,z);

func shiftFloors():
	for i in range(len(floors)):
		floors[i].position=(self.position-get_viewport().size/2)*(pow(sclUp,i)-1);
		walls[i].position=(self.position-get_viewport().size/2)*(pow(sclUp,i)-1);
		for w in walls[i].get_children():
			var a=w.get_child(0).get_polygon();
			a.set(2,a[1]+((self.position-get_viewport().size/2)+(walls[i].position+w.position+a[1])*sclFlat)*pow(sclUp,i+1));
			a.set(3,a[0]+((self.position-get_viewport().size/2)+(walls[i].position+w.position+a[0])*sclFlat)*pow(sclUp,i+1));
			w.get_child(0).set_polygon(a);
			w.get_child(1).set_polygon(a);

func _physics_process(dt):
#	impulse = Vector2(0,0)
#	#x axis
#	if Input.is_action_pressed("ui_right"):
#		impulse.x -=1
#	if Input.is_action_pressed("ui_left"):
#		impulse.x += 1
#	#y axis
#	if Input.is_action_pressed("ui_up"):
#		impulse.y += 1
#	if Input.is_action_pressed("ui_down"):
#		impulse.y -= 1
#	#find current speed
#	impulse = impulse.normalized()
	#it might be better to have this dependent on player position
	self.position = -$Player.position + get_viewport().size/2
	shiftFloors();

	#lightTempV1=clamp(lightTempV1+(randf()-.5)*.01,-5,5);
	#lightTempV2=clamp(lightTempV2+(randf()-.5)*.01,-5,5);
	#lightTempT1+=lightTempV1*dt;
	#lightTempT2+=lightTempV2*dt;
	#lightTemp.position=lightTemp.scale*shiftFlat*Vector2(sin(lightTempT1),sin(lightTempT2));
