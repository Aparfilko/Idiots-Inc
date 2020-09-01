#include <Godot.hpp>
#include <Node.hpp>

#include <InputEvent.hpp>

#include <Camera.hpp>
#include <DirectionalLight.hpp>

#include <Spatial.hpp>
#include <MeshInstance.hpp>
#include <ArrayMesh.hpp>
#include <CubeMesh.hpp>
#include <ShaderMaterial.hpp>
#include <Shader.hpp>

#include <vector>

const float DIMTILE=10.0f;//how big is each tile
const int PADTILEARR=1;//how many tiles pad each direction
const int DIMTILEARR=PADTILEARR*2+1;
const int SIZETILEARR=DIMTILEARR*DIMTILEARR;

namespace godot{
class GDMain:public Node{
	GODOT_CLASS(GDMain,Node)
	public:
	Camera *cam;
	DirectionalLight *dirLight;
	
	Shader *floorShad;
	ShaderMaterial *floorShadMat;
	MeshInstance* floorTiles[SIZETILEARR];
	int xCenterPrev,yCenterPrev;
	
	Spatial *playerBase;
	MeshInstance *playerInst;
	Vector3 posPlayer;
	Vector3 velPlayer;
	unsigned char keyState{};
	float t=0;
	
	float worldHeight(float x,float y){
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
	
	void genWorldTile(float xCenter,float yCenter,int xTileArr,int yTileArr){
		float xOff=xCenter+DIMTILE*xTileArr,yOff=yCenter+DIMTILE*yTileArr;
		MeshInstance** currTile=&floorTiles[DIMTILEARR*(yTileArr+1)+(xTileArr+1)];
		
		ArrayMesh *arrMesh=ArrayMesh::_new();
		Array arr;arr.resize(arrMesh->ARRAY_MAX);
		PoolVector3Array vert;
		PoolVector3Array norm;
		PoolColorArray vertColor;
		PoolIntArray vertInd;
		for(float y=yOff;y<=yOff+DIMTILE;y+=1.0f){
			for(float x=xOff;x<=xOff+DIMTILE;x+=1.0f){
				vert.append(Vector3(x,worldHeight(x,y),y));
				norm.append(worldNorm(x,y));
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
		arr[arrMesh->ARRAY_VERTEX]=vert;
		arr[arrMesh->ARRAY_NORMAL]=norm;
		arr[arrMesh->ARRAY_COLOR]=vertColor;
		arr[arrMesh->ARRAY_INDEX]=vertInd;
		arrMesh->add_surface_from_arrays(arrMesh->PRIMITIVE_TRIANGLES,arr);
		
		add_child(*currTile=MeshInstance::_new());
		(*currTile)->set_mesh(arrMesh);
		(*currTile)->set_surface_material(0,floorShadMat);
	}
	
	void updateWorldTile(float xCenter,float yCenter){
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
				genWorldTile(xCenter,yCenter,1,y);
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
				genWorldTile(xCenter,yCenter,-1,y);
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
				genWorldTile(xCenter,yCenter,x,1);
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
				genWorldTile(xCenter,yCenter,x,-1);
			}
		}
	}
	
	void _init(){
		{//light
		add_child(dirLight=DirectionalLight::_new());
		dirLight->set_rotation(Vector3(-2.5,2.4,0));
		dirLight->set_shadow_mode(0);
		dirLight->set_shadow(1);
		}{//floor
		floorShad=Shader::_new();
		floorShad->set_code(R"(
			shader_type spatial;
			void vertex() {
			}

			void fragment(){
				ALBEDO = COLOR.xyz;
			}
		)");
		floorShadMat=ShaderMaterial::_new();
		floorShadMat->set_shader(floorShad);
		for(int y=-PADTILEARR;y<=PADTILEARR;y++){
			for(int x=-PADTILEARR;x<=PADTILEARR;x++){
				genWorldTile(0.f,0.f,x,y);
			}
		}
		xCenterPrev=0;yCenterPrev=0;
		}{//player
		add_child(playerBase=Spatial::_new());
		playerBase->add_child(playerInst=MeshInstance::_new());
		CubeMesh *cube=CubeMesh::_new();
		cube->set_size(Vector3(.5f,1.f,.5f));
		playerInst->set_mesh(cube);
		playerInst->set_translation(Vector3(0,.5,0));
		posPlayer=Vector3(0,0,0);
		velPlayer=Vector3(0,0,0);
		}{//cam
		playerBase->add_child(cam=Camera::_new());
		cam->set_translation(Vector3(0,5,5));
		cam->set_rotation(Vector3(-.5,0,0));
		}
	}
	
	void _input(InputEvent *in){
		if(in->is_action_type()){//      1,  2,  4,  8, 16, 32,     64,    128
			static const String KEYS[]{"a","q","s","w","d","e","shift","space"};
			unsigned char pressed{},released{};
			for(int i=0;i<8;i++){
				pressed |=(in->is_action_pressed( KEYS[i]))<<i;
				released|=(in->is_action_released(KEYS[i]))<<i;
			}
			keyState|=pressed;keyState&=~released;
		}
	}
	
	void _process(float dt){
		t+=dt;
		
		velPlayer=Vector3(
		((bool)(keyState&16))-((bool)(keyState&1)),
		0,
		((bool)(keyState&4))-((bool)(keyState&8))
		);
		posPlayer+=velPlayer*dt*10;
		posPlayer[1]=worldHeight(posPlayer[0],posPlayer[2]);
		playerBase->set_translation(posPlayer);
		
		updateWorldTile(posPlayer[0],posPlayer[2]);
	}

	static void _register_methods(){
		register_method("_input",&GDMain::_input);
		register_method("_process",&GDMain::_process);
	}
};
}

extern "C" void GDN_EXPORT godot_gdnative_init(godot_gdnative_init_options *o){godot::Godot::gdnative_init(o);}
extern "C" void GDN_EXPORT godot_gdnative_terminate(godot_gdnative_terminate_options *o){godot::Godot::gdnative_terminate(o);}
extern "C" void GDN_EXPORT godot_nativescript_init(void *p){godot::Godot::nativescript_init(p);godot::register_class<godot::GDMain>();}