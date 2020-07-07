extends Node2D

var matFloor=[];
var matObs=[];
var offFloor;
var offObs;

func _ready():
	var xDim;var yDim;
	xDim=$Floor.get_used_rect().size.x;
	yDim=$Floor.get_used_rect().size.y;
	offFloor=$Floor.get_used_rect().position;
	for y in range(yDim):
		matFloor.append([])
		matFloor[y].resize(xDim);
		for x in range(xDim):
			matFloor[y][x]=$Floor.get_cell(offFloor.x+x,offFloor.y+y);
	xDim=$Obs.get_used_rect().size.x;
	yDim=$Obs.get_used_rect().size.y;
	offObs=$Obs.get_used_rect().position;
	for y in range(yDim):
		matObs.append([])
		matObs[y].resize(xDim);
		for x in range(xDim):
			matObs[y][x]=$Obs.get_cell(offObs.x+x,offObs.y+y);
	print(matFloor);
	print(matObs);
