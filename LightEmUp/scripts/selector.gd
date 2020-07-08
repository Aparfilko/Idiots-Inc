extends TileMap

enum {WALL = 0, ALLLAMP = 1,DOWNLAMP = 2, UPLAMP = 3, LEFTLAMP = 4, RIGHTLAMP = 5, NOSELECT = 6, SELECT = 7, PLACE = 10, DELETE = 11}
#m for mode
onready var m = false
var index
onready var prev = [Vector2(-999,-999) ,get_cell(-999,-999), get_cell_autotile_coord(-999,-999)]
var placeable
onready var choose = INVALID_CELL
onready var select = false

func _ready():
	print(INVALID_CELL);
	#connect so buttons do things
	index = world_to_map(get_global_mouse_position())
	
func _process(_dt):
	#canceled, go to normal
	if choose == INVALID_CELL:
		pass
	#should have delete mode here
	elif choose == NOSELECT:
		select = delete()
	#otherwise, hover with selection
	else:
		select = hover(choose)
	
	
func hover(item):
	index = get_parent().get_node("Floor").world_to_map(get_global_mouse_position())
	#don't select over nothing!
	var free = get_parent().get_node("Floor").get_cellv(index) != INVALID_CELL
	#revert previous tiles
	if index != prev[0]:
		set_cell(prev[0].x, prev[0].y, prev[1], false, false, false, prev[2])
		$Selection.set_cell(prev[0].x, prev[0].y, INVALID_CELL, false, false, false, prev[2])
		#grab current tile
		prev = [index, get_cellv(index), get_cell_autotile_coord(index.x, index.y)]
	if prev[1] != WALL and free:
		#you're ok, change it
		if prev[1] == INVALID_CELL:
			$Selection.set_cell(index.x, index.y, SELECT,false,false,false,prev[2])
			set_cell(index.x, index.y, item, false,false,false,prev[2])
			get_parent().update_tiles();
			return true
		#something there, can't select
		else:
			$Selection.set_cell(index.x, index.y, NOSELECT,false,false,false,prev[2])
	return false
	
func delete():
	index = get_parent().get_node("Floor").world_to_map(get_global_mouse_position())
	#revert previous tiles
	#don't select over nothing!
	var free = get_parent().get_node("Floor").get_cellv(index) != INVALID_CELL
	if index != prev[0]:
		set_cell(prev[0].x, prev[0].y, prev[1], false, false, false, prev[2])
		$Selection.set_cell(prev[0].x, prev[0].y, INVALID_CELL, false, false, false, prev[2])
		prev = [index, get_cellv(index), get_cell_autotile_coord(index.x, index.y)]
	if prev[1] != WALL and free:
		#mark this as something to delete
		$Selection.set_cell(index.x, index.y, NOSELECT,false,false,false,prev[2])
		return true
	return false
	
func revert():
	set_cell(prev[0].x, prev[0].y, prev[1], false, false, false, prev[2])
	$Selection.set_cell(prev[0].x, prev[0].y, INVALID_CELL, false, false, false, prev[2])
	
	
func get_choice(c):
	if c == INVALID_CELL:
		choose = c
		revert()
	#place item
	elif c == PLACE:
		#don't let place happen if there's stuff already there
		if select:
			#delete tile
			if choose == NOSELECT:
				set_cell(prev[0].x, prev[0].y, INVALID_CELL, false, false, false, prev[2])
			#place tile
			$Selection.set_cell(prev[0].x, prev[0].y, INVALID_CELL, false, false, false, prev[2])
			prev = [Vector2(-999,-999) ,get_cell(-999,-999), get_cell_autotile_coord(-999,-999)]
	#switch back from delete mode
	elif choose == NOSELECT and c == NOSELECT:
		$Selection.set_cell(prev[0].x, prev[0].y, INVALID_CELL, false, false, false, prev[2])
		prev = [Vector2(-999,-999) ,get_cell(-999,-999), get_cell_autotile_coord(-999,-999)]
		choose = INVALID_CELL
	#select item to place/go into delete mode
	else:
		choose = c
