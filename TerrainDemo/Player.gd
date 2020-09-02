extends Spatial

onready var pTerrainGen=get_parent().get_node("TerrainGen");
var velPast=Vector3();
var velTarget=Vector3();
var velCurr=Vector3();
var velY=0;
var timePast=0;
var timeCurr=0;

func b(b):
	return 1 if b else 0;

func _input(event):
	var velNew=velTarget;
	velNew[0]+=b(event.is_action_pressed("a"))+b(event.is_action_released("d"));
	velNew[0]-=b(event.is_action_pressed("d"))+b(event.is_action_released("a"));
	velNew[2]+=b(event.is_action_pressed("w"))+b(event.is_action_released("s"));
	velNew[2]-=b(event.is_action_pressed("s"))+b(event.is_action_released("w"));
	if(velNew!=velTarget):
		timePast=timeCurr;
		velPast=velCurr;
		velTarget=velNew;
	if(event.is_action_pressed("space")):
		velY=50;

func _process(dt):
	timeCurr+=dt;
	var r=exp(10*(timePast-timeCurr));
	velCurr=(r*velPast+(1-r)*velTarget);
	
	velY-=98.1*dt;
	if(velY<0 and translation[1]<pTerrainGen._worldHeight(translation[0],translation[2])):
		velY=0;
		translation[1]=pTerrainGen._worldHeight(translation[0],translation[2]);
	
	translation+=velCurr*10*dt;
	translation[1]+=velY*dt;
	
	$MeshInstance.rotation=Vector3(.2*velCurr[2],0,-.2*velCurr[0]);
