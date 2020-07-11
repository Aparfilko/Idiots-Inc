extends KinematicBody

onready var ass_mat=[
];

var vel=Vector3();
var acc=0;
var ang=0;
var angVel=0;
var angAcc=0;
var b=[0,0,0,0,0,0];#ign,thrust,lev,left,brake,right

func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	angVel+=(.1*delta if b[3] else 0)-(.1*delta if b[5] else 0);
	ang+=angVel;
	rotation=Vector3(0,ang,0);
	vel+=Quat(Vector3(0,1,0),ang)*Vector3(0,0,(1 if b[1] else 0)-(1 if b[4] else 0));
	var col=move_and_slide(vel);
	if(col):
		pass;

func _input(event):
	b=[
		(b[0] or event.is_action_pressed("q")) and not event.is_action_released("q"),
		(b[1] or event.is_action_pressed("w")) and not event.is_action_released("w"),
		(b[2] or event.is_action_pressed("e")) and not event.is_action_released("e"),
		(b[3] or event.is_action_pressed("a")) and not event.is_action_released("a"),
		(b[4] or event.is_action_pressed("s")) and not event.is_action_released("s"),
		(b[5] or event.is_action_pressed("d")) and not event.is_action_released("d"),
		];
