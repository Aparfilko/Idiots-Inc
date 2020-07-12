extends KinematicBody

var refBooster=[];#right,left,center
var tBooster=[0,0,0];
var isBooster=[false,false,false];

var tic=0;
var vel=Vector3();
var angVel=0;
var b=[0,0,0,0,0,0];#ign,thrust,drift,left,brake,right
onready var engineStart = false

func _ready():
	$RayCast.cast_to=Vector3(0,-40,0);
	refBooster.append($body/booster);
	refBooster.append($body/booster2);
	refBooster.append($body/booster3);

func reset(plugs, breaking, socks):
	vel=Vector3();
	angVel=0;
	b=[0,0,0,0,0,0];
	for i in get_node("Hud/plugs").get_children():
		i.plugOut()
		i.get_node("AnimatedSprite").play("hell")
	$Hud.set_up(plugs, breaking, socks)
	$Pausenode._ready()
	tic=0;

func _physics_process(delta):
	tic+=delta;
	$raceTimer.setTime(tic);
	isBooster[0]=b[3] and $Hud.socks[3];
	isBooster[1]=b[5] and $Hud.socks[5];
	isBooster[2]=(b[1] and $Hud.socks[1]) and ((b[0] and $Hud.socks[0]) or vel.length()>5);
	
	#vel
	var q=Quat(Vector3(0,1,0),rotation[1]);
	vel+=q*Vector3(0,0,
	(10*delta if isBooster[2] else 0)+
	(.5*delta if isBooster[0] else 0)+
	(.5*delta if isBooster[1] else 0)-
	(20*delta if (b[4] and $Hud.socks[4] and (vel.dot(q*Vector3(0,0,1))>-2 or ($Hud.socks[0] and b[0] and vel.dot(q*Vector3(0,0,1))>-10))) else 0));
	vel-=q*Vector3(0 if b[2] and $Hud.socks[2] else 30*delta,0,0)*vel.dot(q*Vector3(1,0,0))
	vel*=(1-.18*delta);
	
	if($RayCast.is_colliding()):
		var d=(translation[1]-$RayCast.get_collision_point()[1]);
		if(d<scale[1]*20):
			vel[1]+=(scale[1]*20-d)*300*delta;
			
	vel[1]-=180*delta;
	vel[1]*=(1-4.2*delta);
	
	var col=move_and_collide(vel*delta);
	if(col):
		vel=.7*vel.bounce(col.normal);
		if abs(col.normal.y) < 0.5 and vel.length() > 12.5 and not $sfx/crash.is_playing():
			$sfx/crash.play()
		col=move_and_collide(col.remainder);
	#ang
	angVel+=(.1*delta if b[3] and $Hud.socks[3] else 0)-(.1*delta if b[5] and $Hud.socks[5] else 0);
	angVel*=(1-3*delta) #angular deceleration when not turning
	rotation[1]+=angVel;
	
	#appearance
	$body.rotation[2]+=(3*delta if b[3] and $Hud.socks[3] else 0)-(3*delta if b[5] and $Hud.socks[5] else 0);
	$body.rotation[2]*=(1-4.8*delta);
	$body.rotation[0]-=(2*delta if ((b[1] and $Hud.socks[1]) and ((b[0] and $Hud.socks[0]) or vel.length()>5)) else 0)-(2*delta if b[4] and $Hud.socks[4] else 0)
	$body.rotation[0]*=(1-12*delta);

	$Camera.rotation[1]=lerp($Camera.rotation[1],PI-vel.dot(q*Vector3(-1,0,0))/(vel.length()),.1);
	$Camera.translation[0]=lerp($Camera.translation[0],17*tan(vel.dot(q*Vector3(-1,0,0))/(vel.length())),.1);
	
	$Hud.mph(3*vel.length());
	$Hud.wheel(-$body.rotation[2]);
	
	tBooster[0]=tBooster[0]+delta if b[3] else 0;
	tBooster[1]=tBooster[1]+delta if b[5] else 0;
	tBooster[2]=tBooster[2]+delta if b[1] else 0;
	refBooster[0].set_ass(isBooster[0],min(1,tBooster[0]));
	refBooster[1].set_ass(isBooster[1],min(1,tBooster[1]));
	refBooster[2].set_ass(isBooster[2],min(1,tBooster[2]));
	sound(b)
	thrust()
	if Input.is_action_just_pressed("shift") and $Hud.socks[0] == 1:
		$sfx/ignition.play()
func _input(event):
	b=[
		(b[0] or event.is_action_pressed("shift")) and not event.is_action_released("shift"),
		(b[1] or event.is_action_pressed("w")) and not event.is_action_released("w"),
		(b[2] or event.is_action_pressed("space")) and not event.is_action_released("space"),
		(b[3] or event.is_action_pressed("a")) and not event.is_action_released("a"),
		(b[4] or event.is_action_pressed("s")) and not event.is_action_released("s"),
		(b[5] or event.is_action_pressed("d")) and not event.is_action_released("d"),
	];
	if event.is_action_pressed("tab"):
		if $Camera.current:
			$Camera.current = false
			$body/Camera2.current = true
		else:
			$body/Camera2.current = false
			$Camera.current = true
		
func sound(br):
	$sfx/left.sound(br[3], $Hud.socks[3])
	$sfx/brake.sound(br[4], $Hud.socks[4])
	$sfx/right.sound(br[5], $Hud.socks[5])

func thrust():
	if (((b[1] and $Hud.socks[1]) and ((b[0] and $Hud.socks[0])) or vel.length()>5)):
		$sfx/thrust.sound(b[1], $Hud.socks[1])
	elif not (b[1] and $Hud.socks[1]) or vel.length()< 5:
		$sfx/thrust.stop()
