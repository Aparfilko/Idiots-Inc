extends Node2D

func _ready():
	$Camera2D.current=true;
	$LightEngine.init(
		$Floor.get_used_rect().size.x,
		$Floor.get_used_rect().size.y,
		$Floor.get_used_rect().position.x,
		$Floor.get_used_rect().position.y);
	update_tiles();

func print_tiles():
	for i in $LightEngine.mat[1]:
		print(i[0]);

func update_tiles():
	for y in range($LightEngine.yDim):
		for x in range($LightEngine.xDim):
			$LightEngine.set_mat(x,y,0,$Floor.get_cell(x,y),$Floor.get_cell_autotile_coord(x,y));
			$LightEngine.set_mat(x,y,1,$Obs.get_cell(x,y),$Obs.get_cell_autotile_coord(x,y));
		$LightEngine.update();
	for i in $Floor.get_used_cells():
		$Floor.set_cell(i.x,i.y,$LightEngine.get_mat(i.x,i.y,0,0),false,false,false,$LightEngine.get_mat(i.x,i.y,0,1));
	for i in $Obs.get_used_cells():
		$Obs.set_cell(i.x,i.y,$LightEngine.get_mat(i.x,i.y,1,0),false,false,false,$LightEngine.get_mat(i.x,i.y,1,1));


func _input(event):
	if event.is_action_pressed("ui_left"):
		$Camera2D.position-=Vector2(48,-16);
	if event.is_action_pressed("ui_right"):
		$Camera2D.position+=Vector2(48,-16);
	if event.is_action_pressed("ui_up"):
		$Camera2D.position+=Vector2(-16,-32);
	if event.is_action_pressed("ui_down"):
		$Camera2D.position-=Vector2(-16,-32);
