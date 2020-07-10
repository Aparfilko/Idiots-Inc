extends Node

var refOverlay;
var refCurr;
onready var resLevel=[
	preload("level/Track1.tscn"),
];

func _ready():
	refCurr=resLevel[0].instance();
	add_child(refCurr);
