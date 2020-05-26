extends Node2D

const shiftX=Vector2(53,22);
const shiftY=Vector2(0,-29);
const shiftZ=Vector2(-24,44);

var origin=Vector2(200,200);
var blockTemplate=[];
func _ready():
	blockTemplate.append(preload("res://BlockBase.tscn"));
	addBlock(0,0,0);
	addBlock(1,1,1);
	
func addBlock(pX,pY,pZ):
	var a=blockTemplate[0].instance();
	a.scale=Vector2(.2,.2);
	a.position=origin+shiftX*pX+shiftY*pY+shiftZ*pZ;
	self.add_child(a);
