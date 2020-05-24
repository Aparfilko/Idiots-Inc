class_name Coin
extends Area2D


# Collectible that disappears when the player touches it, adding to the coin counter
# in the HUD

onready var animation_player = $AnimationPlayer


# The Coins only detects collisions with the Player thanks to its collision mask.
# This prevents other characters such as enemies from picking up coins.

# When the player collides with a coin, the coin plays its 'picked' animation.
# The animation takes cares of making the coin disappear, but also deactivates its
# collisions and frees it from memory, saving us from writing more complex code.
# Click the AnimationPlayer node to see the animation timeline.

#also used body_entered to send a signal to HUD to increment the coin counter
func _ready():
	add_to_group("coins")
	self.connect("body_entered",get_node('/root/Game/InterfaceLayer/HUD'),"coinCollected")

func _on_body_entered(_body):
	if _body.name == "Player":
		animation_player.play("picked")
