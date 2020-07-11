extends KinematicBody

onready var ass_mat=[
];

var vel=Vector3();
var acc=0;
var ang=0;
var angVel=0;
var angAcc=0;
var boosters=[0,0,0,0,0,0];#ing,thrust,lev,left,brake,right

func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	translation+=vel;

func _input(event):
	boosters=[
		(boosters[0] or event.is_action_pressed("q")) and not event.is_action_released("q"),
		(boosters[1] or event.is_action_pressed("w")) and not event.is_action_released("w"),
		(boosters[2] or event.is_action_pressed("e")) and not event.is_action_released("e"),
		(boosters[3] or event.is_action_pressed("a")) and not event.is_action_released("a"),
		(boosters[4] or event.is_action_pressed("s")) and not event.is_action_released("s"),
		(boosters[5] or event.is_action_pressed("d")) and not event.is_action_released("d"),
		];
	print(boosters);
