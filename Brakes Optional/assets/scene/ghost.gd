extends KinematicBody

var gName;
var arrTranslation=[];
var arrRotation=[];
var arrBoost=[];
var t;

func _process(dt):
	t+=dt;
	var indPrev=floor(2*t);
	var ratio=fmod(2*t,1);
	if indPrev+1 >= arrTranslation.size():
		queue_free();
		return;
	translation=lerp(arrTranslation[indPrev],arrTranslation[indPrev+1],ratio);
	rotation[1]=lerp(arrRotation[indPrev],arrRotation[indPrev+1],ratio);
	$body/booster.set_ass(1,1);
	$body/booster2.set_ass(1,1);
	$body/booster3.set_ass(1,1);
