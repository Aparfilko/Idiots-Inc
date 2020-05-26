extends Node2D

const shiftX=Vector2(53,22);
const shiftY=Vector2(0,-29);
const shiftZ=Vector2(-24,44);

var origin=Vector2(200,200);
var blockTemplate=[];
var blockInstance=[];
func _ready():
	blockTemplate.append(preload("res://BlockBase.tscn"));
	genLvl("lvl0.txt");
	
func addBlock(type,pX,pY,pZ):
	var a=blockTemplate[type].instance();
	a.scale=Vector2(.2,.2);
	a.position=origin+shiftX*pX+shiftY*pY+shiftZ*pZ;
	self.add_child(a);

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
