extends Button

func _ready():
	connect("button_down", get_parent().get_node("Obs"), "placeMode")
	connect("button_up", get_parent().get_node("Obs"), "selectMode")

