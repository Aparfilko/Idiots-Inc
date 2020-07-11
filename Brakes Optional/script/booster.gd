extends MeshInstance
var b
var c
var d
var e
var ass_mat;

func set_ass(a):
	$ass.material=ass_mat[a];
func _process(_delta):
	randomize()
	e = (randf()-0.5)
	b = (randf()-0.5)
	c = (randf()-0.5)
	d = (randf()-0.5)
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
