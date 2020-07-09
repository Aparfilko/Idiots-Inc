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
	select = hover(choose)
	
	
func hover(item):
	#I know it's dumb
	index = get_parent().get_node("Floor").world_to_map(get_global_mouse_position()) + Vector2(9,27)
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
			return true
		#something there, can't select
		else:
			$Selection.set_cell(index.x, index.y, NOSELECT,false,false,false,prev[2])
	return false
	
func delete():
	$Selection.set_cell(prev[0].x, prev[0].y, INVALID_CELL, false, false, false, prev[2])
	if not select:
		set_cell(prev[0].x, prev[0].y, INVALID_CELL, false, false, false, prev[2])
		get_parent().update_tiles()
		prev = [Vector2(-999,-999) ,get_cell(-999,-999), get_cell_autotile_coord(-999,-999)]
	
func revert():
	set_cell(prev[0].x, prev[0].y, prev[1], false, false, false, prev[2])
	
	
func get_choice(c):
	c = int(c)
	#
	if c == INVALID_CELL or c == choose:
		choose = INVALID_CELL
		revert()
	#place item
	elif c == PLACE:
		#don't let place happen if there's stuff already there
		if select:
			#place tile
			$Selection.set_cell(prev[0].x, prev[0].y, INVALID_CELL, false, false, false, prev[2])
			get_parent().update_tiles()
			prev = [Vector2(-999,-999) ,get_cell(-999,-999), get_cell_autotile_coord(-999,-999)]
	#delete
	elif c == NOSELECT:
		delete()
		choose = INVALID_CELL
	else:
		choose = c
