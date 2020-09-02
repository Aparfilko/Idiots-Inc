extends Node

func _ready():
	return

func _process(dt):
	$TerrainGen._updateWorldTile($Player.translation[0],$Player.translation[2]);
