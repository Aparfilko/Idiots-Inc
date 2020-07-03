extends Camera

var _x=0
var disp=0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(delta):
	_x+=delta*0.01
	disp=0.1*(sin(_x)+sin(4*_x))
	set("v_offset",disp)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
