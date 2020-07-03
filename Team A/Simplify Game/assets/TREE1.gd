extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var color = get_child(0).mesh.surface_get_material(0).resource_name
	var size = "TALL"
	var type = "NULL"
	if get("scale").x != 1:
		size = "SHORT"
	type = get_child(0).mesh.resource_name
	
	print (size," ",color," ",type)
	print (get("editor_description"))
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
