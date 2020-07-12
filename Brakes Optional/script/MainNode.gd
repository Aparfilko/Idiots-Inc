extends Node

func _ready():
	$ManagerLevel.refOverlay=$ManagerOverlay;
	$ManagerOverlay.refLevel=$ManagerLevel;

#func _input(event):
#	if(event.is_action_pressed("ui_cancel")):
#		get_tree().quit();

