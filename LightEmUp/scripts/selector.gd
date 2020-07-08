extends TileMap

enum {WALL = 0, ALLLAMP = 1,DOWNLAMP = 2, UPLAMP = 3, LEFTLAMP = 4, RIGHTLAMP = 5, NOSELECT = 6, SELECT = 7}
#m for mode
onready var m = false
var index
onready var prev = [Vector2(0,0) ,get_cell(0,0)]

func _ready():
	#connect so buttons do things
	index = world_to_map(get_global_mouse_position())
	get_parent().get_node("Camera2D/User Interface/toolbar/lamp").connect("button_down", self, "placeMode")
	get_parent().get_node("Camera2D/User Interface/toolbar/lamp").connect("button_up", self, "noMode")
	
func _process(_dt):
	index = get_parent().get_node("Floor").world_to_map(get_global_mouse_position())
#	don't select over nothing!
	var free = get_parent().get_node("Floor").get_cell(index[0], index[1]) != INVALID_CELL
	#revert previous tiles
	if index != prev[0]:
		set_cellv(prev[0], prev[1])
		prev = [index, get_cellv(index)]
	#grab current tile
	#print(index)
	#print(prev)
	#you're ok, change it
	if prev[1] == INVALID_CELL and free:
		set_cellv(index, SELECT)
	#something there, can't select
	elif free:
		set_cellv(index, NOSELECT)
		#print("no")
	
	
	
	
func noMode():
	m = WALL
	
func placeMode():
	m = ALLLAMP
