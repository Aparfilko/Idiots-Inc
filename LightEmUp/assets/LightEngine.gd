extends Node2D

var xDim;var yDim;
var xOff;var yOff;
var mat=[[],[]];

func init(xD,yD,xO,yO):
	xDim=xD;yDim=yD;
	xOff=xO;yOff=yO;
	
	for _i in range(yDim*xDim):
		mat[0].append(-1);
		mat[1].append(-1);

func set_mat(x,y,z,id):
	mat[z][y*xDim+x]=id;
