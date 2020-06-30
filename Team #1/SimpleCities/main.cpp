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

namespace godot{
class GDMain:public Spatial{
	GODOT_CLASS(GDMain,Spatial)
	
	typedef struct{
		MeshInstance* inst;
		CubeMesh* cube;
		SpatialMaterial* mat;
	}MeshPart;
	
	void initMeshPart(MeshPart& in,Vector3 size,Vector3 pos,Vector3 rot,Color col){
		add_child(in.inst=MeshInstance::_new());
		in.inst->set_mesh(in.cube=CubeMesh::_new());
		in.cube->set_material(in.mat=SpatialMaterial::_new());
		in.mat->set_albedo(col);
		in.cube->set_size(size);
		in.inst->set_translation(pos);
		in.inst->set_rotation(rot);
	}
	
	Input* input;
	Camera* cam;
	MeshPart floor;
	std::vector<MeshPart> buildPads;
	
	public:
	GDMain(){}
	~GDMain(){}

	void _init(){
		input=Input::get_singleton();
		
		add_child(cam=Camera::_new());
		cam->set_rotation(Vector3(-1.57,0,0));
		cam->set_translation(Vector3(DIM/2.0,5,DIM/2.0));
		
		initMeshPart(floor,Vector3(DIM,1,DIM),Vector3(DIM/2.0,0,DIM/2.0),Vector3(0,0,0),Color(.5,.5,.5));
		
		buildPads.resize(DIM*DIM);
		for(int y=0;y<DIM;y++){
			for(int x=0;x<DIM;x++){
				initMeshPart(buildPads[DIM*y+x],Vector3(.8,1,.8),Vector3(x+.5,.01,y+.5),Vector3(0,0,0),Color(.4,.8,.1));
			}
		}
	}
	
	void _input(InputEvent* in){
		if(in->is_action_pressed("w")){std::cout<<"ITSA'W'"<<std::endl;}
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