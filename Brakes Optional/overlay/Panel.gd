extends Panel


func _ready():
	rect_size = OS.get_window_size()
	$Track1.rect_position.x = OS.get_window_size().x/10
#	$Track2.rect_position.x = OS.get_window_size().x/2 - $Track2.rect_size.x/2
	$Track3.rect_position.x = OS.get_window_size().x*(9/10) - $Track3.rect_size.x
