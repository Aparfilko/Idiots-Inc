extends MeshInstance

var ass_mat;
	
func set_ass(a):
	$ass.material=ass_mat[a];
func _process(delta):
	print($ass.mesh.surface_get_material(0))
	$RedPuff.translate(Vector3(0,2,0))
	if $RedPuff.translation.z >= 50:
		$RedPuff.translation.z = -0.5
	#print($ass.mesh.material.shader.resource_name)# == "on":
	#	$RedPuff.visible = true
	#else:
	#	$RedPuff.visible = false
