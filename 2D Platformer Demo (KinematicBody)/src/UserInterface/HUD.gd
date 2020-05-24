extends Control

#Script for HUD, currently only keeps tracks of coins the player picks up.

onready var total = get_tree().get_nodes_in_group("coins").size()
onready var collected = 0


func _ready():
	$Counter/total.text = String(total)
	$Counter/collected.text = String(collected)
	
func coinCollected(body):
	if body.name == "Player":
		collected = collected + 1
		$Counter/collected.text = String(collected)
	
	
	
	
