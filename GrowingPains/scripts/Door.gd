extends StaticBody2D

#body_shape_entered(body_id: int, body: Node, body_shape: int, area_shape: int)
#ALL DOORS MUST BE THE CHILDREN OF A BUTTON IN ORDER TO WORK
func _ready():
	get_parent().connect("body_shape_entered", self, "_switch")

func _switch(_body_id, node, _body_shape, _area_shape):
	if node.name.match("Player"):
		$CollisionShape2D.call_deferred("set", "disabled", not $CollisionShape2D.is_disabled())
		$AnimatedSprite.call_deferred("set", "visible", not $AnimatedSprite.is_visible())
