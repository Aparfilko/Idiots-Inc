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
		light.append(0);
		
func set_mat(x,y,z,id,atlas):
	mat[z][(y-yOff)*xDim+(x-xOff)]=[id,atlas];

func get_mat(x,y,z,a):
	return mat[z][xDim*(y-yOff)+(x-xOff)][a];

func update():
	for i in range(light.size()):
		light[i]=0;
		
	for y0 in range(yDim):
		for x0 in range(xDim):
			if(mat[1][y0*xDim+x0][0]>0):
				for y1 in range(yDim):
					for x1 in range(xDim):
						light[y1*xDim+x1]+=traceLight(x0,y0,x1,y1);
	
	for y in range(yDim):
		for x in range(xDim):
			var ind=xDim*y+x;
			var l=floor(light[ind]*4);
			if l>=4:
				l=3;
			if(mat[0][ind][0]==0):
				mat[0][ind][1]=Vector2(l*16+l*4+l,0);
			if(mat[1][ind][0]==0):
				mat[1][ind][1]=Vector2(l*16+l*4+l,0);

func traceLight(x0,y0,x1,y1):
	var out=1;
	while(1):
		if(abs(x1-x0)>abs(y1-y0)):
			x0+=1 if x1>x0 else -1;
		else:
			y0+=1 if y1>y0 else -1;
		if(x0==x1 and y0==y1):
			return out;
		elif(mat[1][y0*xDim+x0][0]==0):
			return 0;
		out*=.5;
	return 0;
