extends CollisionShape
onready var cakes = 0
onready var sacr = 0
onready var totalS = get_tree().get_nodes_in_group("guests").size()
onready var totalC = get_tree().get_nodes_in_group("cake").size()


func _ready():
	$cakeCount/cakeCurrent.text = String(cakes)
	$cakeCount/cakeTotal.text = String(totalC)
	$playerCount/playerCurrent.text = String(sacr)
	$playerCount/playerTotal.text = String(totalS)
	$playerCount.hide()

func cakeCount():
	cakes += 1
	$cakeCount/cakeCurrent.text = String(cakes)
	if cakes == totalC:
		$cakeCount.add_color_override("font_color", Color(0,1,0,1))
		$cakeCount/cakeCurrent.add_color_override("font_color", Color(0,1,0,1))
		$cakeCount/cakeTotal.add_color_override("font_color", Color(0,1,0,1))
		$Timer.start()
	
func sacrificeCount():
	sacr += 1
	$playerCount/playerCurrent.text = String(sacr)
	#add something here for when the player wins


func _timeout():
	$playerCount.rect_position.y = $playerCount.rect_position.y - 40
	$playerCount.show()
	$cakeCount.hide()
	
