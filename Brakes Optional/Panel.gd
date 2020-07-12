extends Panel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	rect_size = OS.get_window_size()
	$Label.rect_size.x = OS.get_window_size().x
	$theCreditsLmao.rect_size.x = OS.get_window_size().x
	$Back.rect_position.x = OS.get_window_size().x /2 - 200
	$Back.rect_position.y = OS.get_window_size().y - 100


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Back_pressed():
	visible = false


func _on_credits_pressed():
	visible = true
