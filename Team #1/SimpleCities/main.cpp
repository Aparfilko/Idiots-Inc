#include <Godot.hpp>
#include <Spatial.hpp>
#include <Input.hpp>
#include <InputEvent.hpp>
#include <Camera.hpp>

#include <vector>

namespace godot{
class GDMain:public Spatial{
	GODOT_CLASS(GDMain,Spatial)
	
	Input* input;
	Camera* cam;
	
	public:
	GDMain(){}
	~GDMain(){}

	void _init(){
		input=Input::get_singleton();
		add_child(cam=Camera::_new());
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