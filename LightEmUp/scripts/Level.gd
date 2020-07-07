extends Node2D

var matFloor=[];
var matObs=[];
var offFloor;
var offObs;

func _ready():
	$Camera2D.current=true;
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

func _input(event):
	if event.is_action_pressed("ui_left"):
		$Camera2D.position-=Vector2(48,-16);
	if event.is_action_pressed("ui_right"):
		$Camera2D.position+=Vector2(48,-16);
	if event.is_action_pressed("ui_up"):
		$Camera2D.position+=Vector2(-16,-32);
	if event.is_action_pressed("ui_down"):
		$Camera2D.position-=Vector2(-16,-32);
