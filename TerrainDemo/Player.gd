extends Spatial

onready var pTerrainGen=get_parent().get_node("TerrainGen");
var velPast=Vector3();
var velTarget=Vector3();
var velCurr=Vector3();
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

func _process(dt):
	timeCurr+=5*dt;
	var r=exp(timePast-timeCurr);
	velCurr=(r*velPast+(1-r)*velTarget);
	translation+=velCurr*10*dt;
	translation[1]=pTerrainGen._worldHeight(translation[0],translation[2]);
