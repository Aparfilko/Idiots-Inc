extends Node

func _ready():
	$ManagerLevel.refReplay=$ManagerReplay;
	$ManagerReplay.c=$car;
	$ManagerLevel.nextOne();
