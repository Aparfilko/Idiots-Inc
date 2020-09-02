#include <Godot.hpp>
#include <Node.hpp>

#include <MeshInstance.hpp>
#include <ArrayMesh.hpp>
#include <ShaderMaterial.hpp>
#include <Shader.hpp>

//these are the dimensions regarding a DIMTILEARR x DIMTILEARR matrix,
//where the player is always in the center
const float DIMTILE=20.0f;//how big is each tile
const int PADTILEARR=2;//how many tiles pad each direction
const int DIMTILEARR=PADTILEARR*2+1;//how many tiles make up one side of the tile array
const int SIZETILEARR=DIMTILEARR*DIMTILEARR;//how many tiles are in the whole array

namespace godot{
class GDTerrainGen:public Node{
	GODOT_CLASS(GDTerrainGen,Node)
	public:
	//buncha variable declarations
	ShaderMaterial *mainShadMat;
	MeshInstance* floorTiles[SIZETILEARR];
	int xCenterPrev,yCenterPrev;
	
	//world generation functions
	float _worldHeight(float x,float y){
		return 
		1.f*(sin(0.2f*x)+1)+
		1.f*(sin(0.5f*y)+1)+
		1.f*(sin(0.4f*x+0.3f*y)+1);
	}
	Vector3	worldNorm(float x,float y){
		return Vector3(
		-.2f*cos(0.2f*x)-.4f*cos(0.4f*x+0.3f*y),
		1,
		-.5f*cos(0.5f*x)-.3f*cos(0.4f*x+0.3f*y)
		);
	}
	
	//fill the array at location (xTileArr,yTileArr), (where the center tile contains xCenter,yCenter)
	void genWorldTile(float xCenter,float yCenter,int xTileArr,int yTileArr){
		float xOff=xCenter+DIMTILE*xTileArr,yOff=yCenter+DIMTILE*yTileArr;
		MeshInstance** currTile=&floorTiles[DIMTILEARR*(yTileArr+PADTILEARR)+(xTileArr+PADTILEARR)];
		
		ArrayMesh *arrMesh=ArrayMesh::_new();
		Array arr;arr.resize(arrMesh->ARRAY_MAX);
		PoolVector3Array vertArr;
		PoolVector3Array vertNorm;
		PoolColorArray vertColor;
		PoolIntArray vertInd;
		for(float y=yOff;y<=yOff+DIMTILE;y+=1.0f){
			for(float x=xOff;x<=xOff+DIMTILE;x+=1.0f){
				vertArr.append(Vector3(x,_worldHeight(x,y),y));
				vertNorm.append(worldNorm(x,y));
				vertColor.append(Color(.1f,.4f+.1f*rand()/RAND_MAX,.3f));
			}
		}
		for(int y=0;y<DIMTILE;y++){
			for(int x=0;x<DIMTILE;x++){
				vertInd.append(y*(DIMTILE+1)+x);
				vertInd.append(y*(DIMTILE+1)+x+1);
				vertInd.append((y+1)*(DIMTILE+1)+x);
				vertInd.append(y*(DIMTILE+1)+x+1);
				vertInd.append((y+1)*(DIMTILE+1)+x+1);
				vertInd.append((y+1)*(DIMTILE+1)+x);
			}
		}
		arr[arrMesh->ARRAY_VERTEX]=vertArr;
		arr[arrMesh->ARRAY_NORMAL]=vertNorm;
		arr[arrMesh->ARRAY_COLOR]=vertColor;
		arr[arrMesh->ARRAY_INDEX]=vertInd;
		arrMesh->add_surface_from_arrays(arrMesh->PRIMITIVE_TRIANGLES,arr);
		
		add_child(*currTile=MeshInstance::_new());
		(*currTile)->set_mesh(arrMesh);
		(*currTile)->set_surface_material(0,mainShadMat);
	}
	
	//does nothing if the player is on the same tile as before
	//if they shift tile locations, it shifts the pointers, and generates a new row in the empty spot
	//this function is called externally
	void _updateWorldTile(float xCenter,float yCenter){
		xCenter=floor(xCenter/DIMTILE);
		yCenter=floor(yCenter/DIMTILE);
		int xCenterCurr=(int)xCenter,yCenterCurr=(int)yCenter;
		if(xCenterPrev==xCenterCurr&&yCenterPrev==yCenterCurr){return;}
		xCenter*=DIMTILE;yCenter*=DIMTILE;
		while(xCenterPrev<xCenterCurr){
			xCenterPrev++;
			for(int y=0;y<DIMTILEARR;y++){
				floorTiles[DIMTILEARR*y]->queue_free();
			}
			for(int y=0;y<DIMTILEARR;y++){
				for(int x=0;x<DIMTILEARR-1;x++){
					floorTiles[DIMTILEARR*y+x]=floorTiles[DIMTILEARR*y+x+1];
				}
			}
			for(int y=-PADTILEARR;y<=PADTILEARR;y++){
				genWorldTile(xCenter,yCenter,PADTILEARR,y);
			}
		}
		while(xCenterPrev>xCenterCurr){
			xCenterPrev--;
			for(int y=0;y<DIMTILEARR;y++){
				floorTiles[DIMTILEARR*(y+1)-1]->queue_free();
			}
			for(int y=0;y<DIMTILEARR;y++){
				for(int x=DIMTILEARR-1;x>0;x--){
					floorTiles[DIMTILEARR*y+x]=floorTiles[DIMTILEARR*y+x-1];
				}
			}
			for(int y=-PADTILEARR;y<=PADTILEARR;y++){
				genWorldTile(xCenter,yCenter,-PADTILEARR,y);
			}
		}
		while(yCenterPrev<yCenterCurr){
			yCenterPrev++;
			for(int x=0;x<DIMTILEARR;x++){
				floorTiles[x]->queue_free();
			}
			for(int y=0;y<DIMTILEARR-1;y++){
				for(int x=0;x<DIMTILEARR;x++){
					floorTiles[DIMTILEARR*y+x]=floorTiles[DIMTILEARR*(y+1)+x];
				}
			}
			for(int x=-PADTILEARR;x<=PADTILEARR;x++){
				genWorldTile(xCenter,yCenter,x,PADTILEARR);
			}
		}
		while(yCenterPrev>yCenterCurr){
			yCenterPrev--;
			for(int x=0;x<DIMTILEARR;x++){
				floorTiles[DIMTILEARR*(DIMTILEARR-1)+x]->queue_free();
			}
			for(int y=DIMTILEARR-1;y>0;y--){
				for(int x=0;x<DIMTILEARR;x++){
					floorTiles[DIMTILEARR*y+x]=floorTiles[DIMTILEARR*(y-1)+x];
				}
			}
			for(int x=-PADTILEARR;x<=PADTILEARR;x++){
				genWorldTile(xCenter,yCenter,x,-PADTILEARR);
			}
		}
	}
	
	//first thing that runs
	void _init(){
		Shader *mainShad=Shader::_new();
		mainShad->set_code("shader_type spatial;void fragment(){ALBEDO=COLOR.xyz;}");
		mainShadMat=ShaderMaterial::_new();
		mainShadMat->set_shader(mainShad);
		for(int y=-PADTILEARR;y<=PADTILEARR;y++){
			for(int x=-PADTILEARR;x<=PADTILEARR;x++){
				genWorldTile(0.f,0.f,x,y);
			}
		}
		xCenterPrev=0;yCenterPrev=0;
	}

	static void _register_methods(){
		register_method("_updateWorldTile",&GDTerrainGen::_updateWorldTile);
		register_method("_worldHeight",&GDTerrainGen::_worldHeight);
	}
};
}

extern "C" void GDN_EXPORT godot_gdnative_init(godot_gdnative_init_options *o){godot::Godot::gdnative_init(o);}
extern "C" void GDN_EXPORT godot_gdnative_terminate(godot_gdnative_terminate_options *o){godot::Godot::gdnative_terminate(o);}
extern "C" void GDN_EXPORT godot_nativescript_init(void *p){godot::Godot::nativescript_init(p);godot::register_class<godot::GDTerrainGen>();}