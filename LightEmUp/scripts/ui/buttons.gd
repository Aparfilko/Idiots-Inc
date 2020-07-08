extends Button

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("pressed", get_parent().get_parent(), "_activateLamp", [int(name)])


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
