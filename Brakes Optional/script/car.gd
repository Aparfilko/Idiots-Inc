extends KinematicBody

onready var ass_mat=[
];

var vel=Vector3();
var angVel=0;
var b=[0,0,0,0,0,0];#ign,thrust,lev,left,brake,right

func _ready():
	$RayCast.cast_to=Vector3(0,-40,0);
	pass # Replace with function body.

func _physics_process(delta):
	angVel+=(.1*delta if b[3] else 0)-(.1*delta if b[5] else 0);
	angVel*=.95 #angular deceleration when not turning
	
	var q=Quat(Vector3(0,1,0),rotation[1]);
	vel+=q*Vector3(0,0,(10*delta if b[1] else 0)+(3*delta if b[3] else 0)+(3*delta if b[5] else 0)-(20*delta if b[4] else 0));
	vel-=q*Vector3(.5,0,0)*vel.dot(q*Vector3(1,0,0))
	
	if($RayCast.is_colliding()):
		var d=(translation[1]-$RayCast.get_collision_point()[1]);
		if(d<scale[1]*(40 if b[2] else 10)):
			vel[1]+=(scale[1]*(40 if b[2] else 10)-d)*200*delta;
	vel[1]-=30*delta;
	vel[1]*=.93;
	
	rotation[1]+=angVel;
	$body.rotation[2]+=(.05 if b[3] else 0)-(.05 if b[5] else 0);
	$body.rotation[2]*=.92;
	var _col=move_and_slide(vel);

func _input(event):
	b=[
		(b[0] or event.is_action_pressed("q")) and not event.is_action_released("q"),
		(b[1] or event.is_action_pressed("w")) and not event.is_action_released("w"),
		(b[2] or event.is_action_pressed("e")) and not event.is_action_released("e"),
		(b[3] or event.is_action_pressed("a")) and not event.is_action_released("a"),
		(b[4] or event.is_action_pressed("s")) and not event.is_action_released("s"),
		(b[5] or event.is_action_pressed("d")) and not event.is_action_released("d"),
		];
	if event.is_action_pressed("space"):
		$WinState.visible = not $WinState.visible
