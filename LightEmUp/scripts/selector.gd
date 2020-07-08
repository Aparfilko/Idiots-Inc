extends TileMap

enum {WALL = 0, ALLLAMP = 1,DOWNLAMP = 2, UPLAMP = 3, LEFTLAMP = 4, RIGHTLAMP = 5, NOSELECT = 6, SELECT = 7, NOSELECTW = 8}
#m for mode
onready var m = false
var index
onready var prev = [Vector2(0,0) ,get_cell(0,0)]
var placeable
onready var choose = ALLLAMP

func _ready():
	#connect so buttons do things
	index = world_to_map(get_global_mouse_position())
	get_parent().get_node("Camera2D/User Interface/toolbar/lamp").connect("button_down", self, "placeMode")
	get_parent().get_node("Camera2D/User Interface/toolbar/lamp").connect("button_up", self, "noMode")
	
func _process(_dt):
	if choose != INVALID_CELL:
		placeable = hover(choose)
	
	
func hover(item):
	index = get_parent().get_node("Floor").world_to_map(get_global_mouse_position())
	#don't select over nothing!
	var free = get_parent().get_node("Floor").get_cellv(index) != INVALID_CELL
	#revert previous tiles
	if index != prev[0]:
		set_cellv(prev[0], prev[1])
		$Selection.set_cellv(prev[0], INVALID_CELL)
		#grab current tile
		prev = [index, get_cellv(index)]
	if item != INVALID_CELL and free:
		#you're ok, change it
		if prev[1] == INVALID_CELL:
			$Selection.set_cellv(index, SELECT)
			set_cellv(index, item)
			return true
		#something there, can't select
		#this is here because I can't figure out how to keep selection from drawing underneath obs, whoops!
		elif prev[1] == WALL:
			$Selection.set_cellv(index, NOSELECTW)
		else:
			$Selection.set_cellv(index, NOSELECT)
	return false
	
func noMode():
	m = WALL
	
func placeMode():
	m = ALLLAMP
