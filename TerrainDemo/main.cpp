#include <Godot.hpp>
#include <Node.hpp>

#include <InputEvent.hpp>

#include <Camera.hpp>
#include <DirectionalLight.hpp>

#include <MeshInstance.hpp>
#include <ArrayMesh.hpp>
#include <CubeMesh.hpp>
#include <ShaderMaterial.hpp>
#include <Shader.hpp>

#include <vector>

#define DIMVERT 99.0f

namespace godot{
class GDMain:public Node{
	GODOT_CLASS(GDMain,Node)
	public:
	Camera* cam;
	DirectionalLight* dirLight;
	MeshInstance *floorInst;
	MeshInstance *playerInst;
	unsigned char keyState{};
	float t=0;
	
	float worldHeight(float x,float y){
		return sin(0.4f*x)+sin(0.4f*y);
	}
	
	Vector3	worldNorm(float x,float y){
		return Vector3(-0.7071f*cos(0.4f*x),0.2071f+0.5f*sin(0.4f*x)*sin(0.4f*x),-0.7071f*cos(0.4f*x));
	}
	
	void _init(){
		{//cam+light
		add_child(cam=Camera::_new());
		cam->set_translation(Vector3(5,10,5));
		cam->set_rotation(Vector3(-1.50,0,0));
		add_child(dirLight=DirectionalLight::_new());
		dirLight->set_rotation(Vector3(-2.2,0.5,0));
		dirLight->set_shadow_mode(0);
		dirLight->set_shadow(1);
		}{//floor
		ArrayMesh *arrMesh=ArrayMesh::_new();
		Array arr;arr.resize(arrMesh->ARRAY_MAX);
		PoolVector3Array vert;
		PoolVector3Array norm;
		PoolColorArray vertColor;
		PoolIntArray vertInd;
		int i=0;
		for(float y=0;y<=DIMVERT;y+=1.0f){
			for(float x=0;x<=DIMVERT;x+=1.0f){
				vert.append(Vector3(x,worldHeight(x,y),y));
				norm.append(worldNorm(x,y));
				vertColor.append(Color(.1f,.4f+.1f*rand()/RAND_MAX,.3f));
			}
		}
		for(int y=0;y<DIMVERT;y++){
			for(int x=0;x<DIMVERT;x++){
				vertInd.append(y*(DIMVERT+1)+x);
				vertInd.append(y*(DIMVERT+1)+x+1);
				vertInd.append((y+1)*(DIMVERT+1)+x);
				vertInd.append(y*(DIMVERT+1)+x+1);
				vertInd.append((y+1)*(DIMVERT+1)+x+1);
				vertInd.append((y+1)*(DIMVERT+1)+x);
			}
		}
		arr[arrMesh->ARRAY_VERTEX]=vert;
		arr[arrMesh->ARRAY_NORMAL]=norm;
		arr[arrMesh->ARRAY_COLOR]=vertColor;
		arr[arrMesh->ARRAY_INDEX]=vertInd;
		arrMesh->add_surface_from_arrays(arrMesh->PRIMITIVE_TRIANGLES,arr);
		Shader *shad=Shader::_new();
		shad->set_code(R"(
			shader_type spatial;
			void vertex() {
			}

			void fragment(){
				ALBEDO = COLOR.xyz;
			}
		)");
		ShaderMaterial *shadMat=ShaderMaterial::_new();
		shadMat->set_shader(shad);
		add_child(floorInst=MeshInstance::_new());
		floorInst->set_mesh(arrMesh);
		floorInst->set_surface_material(0,shadMat);
		}{//player
		add_child(playerInst=MeshInstance::_new());
		CubeMesh *cube=CubeMesh::_new();
		cube->set_size(Vector3(.5,1,.5));
		playerInst->set_mesh(cube);
		
		}
	}
	
	void _input(InputEvent* in){
		if(in->is_action_type()){
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