extends Node

func _ready():
	$ManagerLevel.refReplay=$ManagerReplay;
	$ManagerReplay.refLevel=$ManagerLevel;
