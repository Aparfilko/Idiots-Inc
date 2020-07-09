extends Node2D

var xDim;var yDim;
var xOff;var yOff;
var mat=[[],[]];
var light=[];

func init(xD,yD,xO,yO):
	xDim=xD;yDim=yD;
	xOff=xO;yOff=yO;
	
	for _i in range(yDim*xDim):
		mat[0].append([-1,Vector2(0,0)]);
		mat[1].append([-1,Vector2(0,0)]);
	for _i in range(yDim*xDim):
		light.append(Vector3(0,0,0));
		
func set_mat(x,y,z,id,atlas):
	mat[z][(y-yOff)*xDim+(x-xOff)]=[id,atlas];

func get_mat(x,y,z,a):
	return mat[z][xDim*(y-yOff)+(x-xOff)][a];

func update():
	for i in range(light.size()):
		light[i]=Vector3(0,0,0);
		
	for y0 in range(yDim):
		for x0 in range(xDim):
			if(mat[1][y0*xDim+x0][0]>0):
				for y1 in range(yDim):
					for x1 in range(xDim):
						light[y1*xDim+x1]+=traceLight(mat[1][y0*xDim+x0][0],mat[1][y0*xDim+x0][1][0],x0,y0,x1,y1);
	
	for y in range(yDim):
		for x in range(xDim):
			var ind=xDim*y+x;
			var l=[min(floor(light[ind][0]*4),3),min(floor(light[ind][1]*4),3),min(floor(light[ind][2]*4),3)];
			if(mat[0][ind][0]==0):
				mat[0][ind][1]=Vector2(l[2]*16+l[1]*4+l[0],0);
			if(mat[1][ind][0]==0):
				mat[1][ind][1]=Vector2(l[2]*16+l[1]*4+l[0],0);

func traceLight(type,atlas,x0,y0,x1,y1):
	if(type==2 and (y1>y0 or abs(x0-x1)>(y0-y1))):
		return Vector3(0,0,0);
	if(type==3 and (y1<y0 or abs(x0-x1)>(y1-y0))):
		return Vector3(0,0,0);
	if(type==4 and (x1>x0 or abs(y0-y1)>(x0-x1))):
		return Vector3(0,0,0);
	if(type==5 and (x1<x0 or abs(y0-y1)>(x1-x0))):
		return Vector3(0,0,0);
	
	var out = [Vector3(1,1,1),
	Vector3(1,0,0),
	Vector3(0,1,0),
	Vector3(0,0,1),
	Vector3(1,1,0),
	Vector3(0,1,1),
	Vector3(1,0,1)][atlas];
	
	out*=1/pow((sqrt(pow(x1-x0,2)+pow(y1-y0,2))+4.5)/4.5,2);
	while(x0!=x1 and y0!=y1):
		if(abs(x1-x0)>abs(y1-y0)):
			x0+=1 if x1>x0 else -1;
		else:
			y0+=1 if y1>y0 else -1;
		if(mat[1][y0*xDim+x0][0]==0):
			return Vector3(0,0,0);
	return out;
