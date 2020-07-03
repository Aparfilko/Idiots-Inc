extends CollisionShape

var type = 0
var color = 0

func _ready():
	set_process_input(true)
	
func get_object_under_mouse():
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_from = get_parent().get_parent().get_parent().get_child(0).project_ray_origin(mouse_pos)
	var RAY_LENGTH = 100
	var ray_to = ray_from + get_parent().get_parent().get_parent().get_child(0).project_ray_normal(mouse_pos) * RAY_LENGTH
	var space_state = get_world().direct_space_state
	var selection = space_state.intersect_ray(ray_from, ray_to)
	if selection:
		return selection["collider"].get_child(1) == self
	else:
		return false
	
func _input(event):
	if get_object_under_mouse() == true:
		var x = get_parent().get_parent().get_translation().x
		var z = get_parent().get_parent().get_translation().z
		if event.is_action_pressed("left_click"):
			type = 2
		elif event.is_action_pressed("right_click"):
			type = 3
		elif event.is_action_pressed("middle_click"):
			type = 0
		get_parent().get_parent().get_parent()._foundation_place_building(x,z,2,type)
