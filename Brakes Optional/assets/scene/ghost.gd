extends KinematicBody

var gName;
var arrTranslation=[];
var arrRotation=[];
var arrRoll=[];
var arrBoost=[];
var t;

func _process(dt):
	t+=dt;
	var indPrev=floor(10*t);
	var ratio=fmod(10*t,1);
	if indPrev+1 >= arrTranslation.size():
		queue_free();
		return;
	translation=lerp(arrTranslation[indPrev],arrTranslation[indPrev+1],ratio);
	rotation[1]=lerp(arrRotation[indPrev],arrRotation[indPrev+1],ratio);
	$body.rotation[2]=lerp(arrRoll[indPrev],arrRoll[indPrev+1],ratio);
	$body/booster.set_ass(arrBoost[indPrev][0],1);
	$body/booster2.set_ass(arrBoost[indPrev][1],1);
	$body/booster3.set_ass(arrBoost[indPrev][2],1);
