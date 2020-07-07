extends Node2D

func _ready():
	print("Floor:")
	for i in $Floor.get_used_cells():
		print(i);
	print("Obs:")
	for i in $Obs.get_used_cells():
		print(i);
