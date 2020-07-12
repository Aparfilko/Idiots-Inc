extends Panel


func _ready():
	visible = false
	rect_size = OS.get_window_size()
	$Label.rect_size.x = OS.get_window_size().x
	$theCreditsLmao.rect_size.x = OS.get_window_size().x
	$Back.rect_position.x = OS.get_window_size().x /2 - 200
	$Back.rect_position.y = OS.get_window_size().y - 100
	$Sprite.position.x = OS.get_window_size().x - 300
	$Sprite2.position.x = 300

func _on_Back_pressed():
	visible = false

func _on_credits_pressed():
	visible = true
