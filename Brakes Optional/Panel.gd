extends Panel


func _ready():
	visible = false
	rect_size = OS.get_window_size()
	$Label.rect_size.x = 1920
	$theCreditsLmao.rect_size.x = 1920
	$Back.rect_position.x = 960 - 200
	$Back.rect_position.y = 1080 - 100
	$Sprite.position.x = 1920 - 300
	$Sprite2.position.x = 300

func _on_Back_pressed():
	visible = false

func _on_credits_pressed():
	visible = true
