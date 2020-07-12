extends KinematicBody

var refBooster=[];#right,left,center
var tBooster=[0,0,0];

var vel=Vector3();
var angVel=0;
var b=[0,0,0,0,0,0];#ign,thrust,drift,left,brake,right

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

func _physics_process(delta):
	#vel
	var q=Quat(Vector3(0,1,0),rotation[1]);
	vel+=q*Vector3(0,0,
	(10*delta if ((b[1] and $Hud.socks[1]) and ((b[0] and $Hud.socks[0]) or vel.length()>5)) else 0)+
	(.5*delta if b[3] and $Hud.socks[3] else 0)+
	(.5*delta if b[5] and $Hud.socks[5] else 0)-
	(20*delta if (b[4] and $Hud.socks[4] and (vel.dot(q*Vector3(0,0,1))>-2 or ($Hud.socks[0] and b[0] and vel.dot(q*Vector3(0,0,1))>-10))) else 0));
	vel-=q*Vector3(0 if b[2] and $Hud.socks[2] else 30*delta,0,0)*vel.dot(q*Vector3(1,0,0))
	vel*=(1-.18*delta);
	
	if($RayCast.is_colliding()):
		var d=(translation[1]-$RayCast.get_collision_point()[1]);
		if(d<scale[1]*20):
			vel[1]+=(scale[1]*20-d)*100*delta;
	vel[1]-=60*delta;
	vel[1]*=(1-4.2*delta);
	
	var col=move_and_collide(vel*delta);
	if(col):
		vel=vel.bounce(col.normal);
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
	
	$Hud.mph(10*vel.length());
	$Hud.wheel(-$body.rotation[2]);
	
	tBooster[0]=tBooster[0]+delta if b[3] else 0;
	tBooster[1]=tBooster[1]+delta if b[5] else 0;
	tBooster[2]=tBooster[2]+delta if b[1] else 0;
	refBooster[0].set_ass(b[3] and $Hud.socks[3],min(1,tBooster[0]));
	refBooster[1].set_ass(b[5] and $Hud.socks[5],min(1,tBooster[1]));
	refBooster[2].set_ass((b[1] and $Hud.socks[1]) and ((b[0] and $Hud.socks[0]) or vel.length()>5),min(1,tBooster[2]));

func _input(event):
	b=[
		(b[0] or event.is_action_pressed("shift")) and not event.is_action_released("shift"),
		(b[1] or event.is_action_pressed("w")) and not event.is_action_released("w"),
		(b[2] or event.is_action_pressed("space")) and not event.is_action_released("space"),
		(b[3] or event.is_action_pressed("a")) and not event.is_action_released("a"),
		(b[4] or event.is_action_pressed("s")) and not event.is_action_released("s"),
		(b[5] or event.is_action_pressed("d")) and not event.is_action_released("d"),
	];
