shader_type spatial;
void fragment(){
	float red, green, blue;
	float r = 15.0;
	float a = 1.30;
	float b = 1.10;
	red = .7 + .3*sin(VERTEX[1]*TIME*r)+.3*sin(VERTEX[2]*TIME*r);
	green = .1 + .1*sin(TIME/a);
	blue = .1 + .1*sin(TIME/b);
	ALBEDO= vec3(red,green,blue);
}