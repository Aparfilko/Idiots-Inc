extends Control

#Script for HUD, currently only keeps tracks of coins the player picks up.

#need a way to provide the count of coins per level, for now it's hardcoded here
var total = 40
var collected = 0



func _ready():
	add_to_group("coinCounter")
	$Counter/total.text = String(total)
	$Counter/collected.text = String(collected)
	
func coinCollected():
	collected = collected + 1
	_ready()
	
	
	
	
