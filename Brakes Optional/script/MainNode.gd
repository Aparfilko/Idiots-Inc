extends Node

func _ready():
	$ManagerLevel.refOverlay=$ManagerOverlay;
	$ManagerOverlay.refLevel=$ManagerLevel;
