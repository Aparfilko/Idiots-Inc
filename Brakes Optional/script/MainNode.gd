extends Node

func _ready():
	$ManagerLevel.refReplay=$ManagerReplay;
	$ManagerReplay.c=$car;
	$ManagerReplay.cb=$car/body;
	$ManagerLevel.nextOne();
	$ManagerReplay.recordStart($ManagerLevel.cnt,$ManagerLevel.onlyNemesis);
