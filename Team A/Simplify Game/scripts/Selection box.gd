extends Area2D



onready var number = name.ord_at(6)-49
onready var amount = get_tree().get_root().get_node("Node/World 1")
var c
signal heldCard(c)
signal freeCard(c)


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", get_parent(), "_in_Select", [self])
	connect("body_exited", get_parent(), "_out_Select", [self])
	connect("heldCard", amount, "listCard", [c, number])
	connect("freeCard", amount, "deleteCard", [c])
	


#register what card is being held
func held(card, _t):
	c = card
	emit_signal("heldCard", c, number)

#delete the card being held
func freed():
	c = null
	emit_signal("freeCard",number)

