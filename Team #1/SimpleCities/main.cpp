#include <Godot.hpp>
#include <Spatial.hpp>
#include <Input.hpp>
#include <InputEvent.hpp>
#include <Vector3.hpp>
#include <Camera.hpp>
#include <MeshInstance.hpp>
#include <CubeMesh.hpp>
#include <SpatialMaterial.hpp>

#include <vector>

#define DIM 5
#define MATSNUM 4
#define CUBESNUM 7

namespace godot{
class GDMain:public Spatial{
	GODOT_CLASS(GDMain,Spatial)
	
	void initMeshPart(MeshInstance* &in,int cube,Vector3 pos=Vector3(0,0,0),Vector3 rot=Vector3(0,0,0)){
		add_child(in=MeshInstance::_new());
		in->set_mesh(cubes[cube]);
		in->set_translation(pos);
		in->set_rotation(rot);
	}
	
	SpatialMaterial* mats[MATSNUM];//grass,road,roadCurb,building0
	CubeMesh* cubes[CUBESNUM];//floorTile,roadCenter,roadCorner,roadCurbCenter,roadCurbCorner,buildingMain,buildingConn
	
	Input* input;
	Camera* cam;
	std::vector<MeshInstance*> buildPads;
	
	public:
	GDMain(){}
	~GDMain(){}

	void _init(){
		input=Input::get_singleton();
		add_child(cam=Camera::_new());
		cam->set_rotation(Vector3(-1.57,0,0));
		cam->set_translation(Vector3(0,5,0));
		
		{
		for(int i=0;i<MATSNUM;i++){mats[i]=SpatialMaterial::_new();}
		mats[0]->set_albedo(Color(.2,.7,.4));
		mats[1]->set_albedo(Color(.2,.2,.6));
		mats[2]->set_albedo(Color(.9,.4,.2));
		mats[3]->set_albedo(Color(.0,.4,.9));
		}{
		for(int i=0;i<CUBESNUM;i++){cubes[i]=CubeMesh::_new();}
		cubes[0]->set_size(Vector3(.98,1,.98));
		cubes[0]->set_material(mats[0]);
		cubes[1]->set_size(Vector3(.8,1.2,.2));
		cubes[1]->set_material(mats[1]);
		cubes[2]->set_size(Vector3(.2,1.2,.2));
		cubes[2]->set_material(mats[1]);
		cubes[3]->set_size(Vector3(.8,1.3,.02));
		cubes[3]->set_material(mats[2]);
		cubes[4]->set_size(Vector3(.2,1.3,.2));
		cubes[4]->set_material(mats[2]);
		cubes[5]->set_size(Vector3(.8,1,.8));
		cubes[5]->set_material(mats[3]);
		cubes[6]->set_size(Vector3(.7,1,.7));
		cubes[6]->set_material(mats[3]);
		}
		
		FILE* fid=fopen("lvl0.cty","r");
		char line[256];
		int xDim,yDim;
		fgets(line,256,fid);
		sscanf(line,"%d%d",&xDim,&yDim);
		cam->set_translation(Vector3(xDim,5,yDim));
		fgets(line,256,fid);
		sscanf(line,"%d%d",&xDim,&yDim);
		int lvl[yDim*xDim]{};
		
		while(fgets(line,256,fid)){
			if(line[0]=='\n'||line[0]=='#'){continue;}
			if(line[0]=='='){break;}
			int a,b,c,d;
			int e=sscanf(line,"%d%d%d%d",&a,&b,&c,&d);
			if(e<2){continue;}
			if(e<4){c=a;d=b;}
			
			for(int y=b;y<=d;y++){
				for(int x=a;x<=c;x++){
					lvl[y*xDim+x]=1;
					buildPads.push_back(NULL);
					initMeshPart(buildPads.back(),0,Vector3(x,0,y));
				}
			}
		}
		fclose(fid);
	}
	
	void _input(InputEvent* in){
		if(in->is_action_pressed("w")){cam->set_translation(cam->get_translation()+Vector3(0,0,-1));}
		if(in->is_action_pressed("a")){cam->set_translation(cam->get_translation()+Vector3(-1,0,0));}
		if(in->is_action_pressed("s")){cam->set_translation(cam->get_translation()+Vector3(0,0,1));}
		if(in->is_action_pressed("d")){cam->set_translation(cam->get_translation()+Vector3(1,0,0));}
	}
	
	void _process(float dt){}

	static void _register_methods(){
		register_method("_input",&GDMain::_input);
		register_method("_process",&GDMain::_process);
	}
};
}

extern "C" void GDN_EXPORT godot_gdnative_init(godot_gdnative_init_options *o){godot::Godot::gdnative_init(o);}
extern "C" void GDN_EXPORT godot_gdnative_terminate(godot_gdnative_terminate_options *o){godot::Godot::gdnative_terminate(o);}
extern "C" void GDN_EXPORT godot_nativescript_init(void *p){godot::Godot::nativescript_init(p);godot::register_class<godot::GDMain>();}