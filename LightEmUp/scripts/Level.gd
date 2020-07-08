extends Node2D

func _ready():
	print($Floor.get_used_rect());
	$Camera2D.current=true;
	$LightEngine.init(
		$Floor.get_used_rect().size.x,
		$Floor.get_used_rect().size.y,
		$Floor.get_used_rect().position.x,
		$Floor.get_used_rect().position.y);
	for i in $Floor.get_used_cells():
		$LightEngine.set_mat(i.x,i.y,0,$Floor.get_cell(i.x,i.y));
	for i in $Obs.get_used_cells():
		$LightEngine.set_mat(i.x,i.y,1,$Obs.get_cell(i.x,i.y));

func _input(event):
	if event.is_action_pressed("ui_left"):
		$Camera2D.position-=Vector2(48,-16);
	if event.is_action_pressed("ui_right"):
		$Camera2D.position+=Vector2(48,-16);
	if event.is_action_pressed("ui_up"):
		$Camera2D.position+=Vector2(-16,-32);
	if event.is_action_pressed("ui_down"):
		$Camera2D.position-=Vector2(-16,-32);
