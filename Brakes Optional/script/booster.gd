extends MeshInstance

var ass_mat;

func set_ass(a):
	$ass.material=ass_mat[a];
func _process(delta):
	print($ass.get_surface_material(0).resource_name)
	$RedPuff.translate(Vector3(0,1,0))
	$RedPuff.translate(Vector3(0,2,0))
	if $RedPuff.translation.z >= 50:
		$RedPuff.translation.z = -0.5
	if $BlackPuff.translation.z >= 50:
		$BlackPuff.translation.z = -0.5
		
	if $ass.get_surface_material(0).resource_name == "ON":
		$RedPuff.visible = true
		$BlackPuff.visible = true
	else:
		$RedPuff.visible = false
		$BlackPuff.visible = false
