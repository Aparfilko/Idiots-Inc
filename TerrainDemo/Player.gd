extends Spatial

onready var pTerrainGen=get_parent().get_node("TerrainGen");
var vel=Vector3();

func b(b):
	return 1 if b else 0;

func _input(event):
	vel[0]+=b(event.is_action_pressed("a"))+b(event.is_action_released("d"));
	vel[0]-=b(event.is_action_pressed("d"))+b(event.is_action_released("a"));
	vel[2]+=b(event.is_action_pressed("w"))+b(event.is_action_released("s"));
	vel[2]-=b(event.is_action_pressed("s"))+b(event.is_action_released("w"));
	
func _process(dt):
	translation+=vel*10*dt;
	translation[1]=pTerrainGen._worldHeight(translation[0],translation[2]);
