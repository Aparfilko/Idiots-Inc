extends MeshInstance

onready var ass_mat=[
	preload("res://assets/scene/off.tres").duplicate(true),
	preload("res://assets/scene/on.tres").duplicate(true),
];

var ass_ind;

func set_ass(a,b):
	if ass_ind!=a:
		$ass.set_surface_material(0,ass_mat[1 if a else 0]);
		ass_ind=a;
	ass_mat[1].set_shader_param("uIn",b);

func _process(_delta):
	randomize()
	var e = (randf()-0.5)
	var b = (randf()-0.5)
	var c = (randf()-0.5)
	var d = (randf()-0.5)
	$RedPuff.translate(Vector3(e,3,b))
	$BlackPuff.translate(Vector3(c,d,2.5))
	if $RedPuff.translation.z >= 30:
		$RedPuff.translation = Vector3(e,b,-0.5)
	if $BlackPuff.translation.z >= 30:
		$BlackPuff.translation = Vector3(c,d,-0.5)
		
	if $ass.get_surface_material(0).resource_name == "ON":
		#$RedPuff.visible = true
		$BlackPuff.visible = true
	else:
		$RedPuff.visible = false
		$BlackPuff.visible = false
