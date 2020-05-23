#include <Godot.hpp>
#include <KinematicBody2D.hpp>
#include <Vector2.hpp>
#include <Input.hpp>
#include <Sprite.hpp>
#include <AnimationPlayer.hpp>
#include <Timer.hpp>
#include <String.hpp>
#include <cmath>

namespace godot{
class Player:public KinematicBody2D{
	GODOT_CLASS(Player,KinematicBody2D)
	
	Input* input;
	Sprite* sprite;
	Node* gun;
	AnimationPlayer* animation_player;
	Timer* shoot_timer;
	
	float gravity=1000.0f;
	Vector2 _velocity=Vector2(0,0);
	float timeJump=1.0f;
	
	public:
	Player(){}
	~Player(){}
	static void _register_methods(){
		register_method("_ready",&Player::_ready);
		register_method("_physics_process",&Player::_physics_process);
	}
	
	Vector2 get_direction(){
		Vector2 out=Vector2(input->get_action_strength("move_right")-input->get_action_strength("move_left"),0);
		if(is_on_floor() and input->is_action_just_pressed("jump")){
			out[1]=-1;
			timeJump=0.0f;
		}else if(timeJump<.1 and input->is_action_pressed("jump")){
			out[1]=-1;
		}
		return out;
	}
	
	Vector2 calculate_move_velocity(Vector2 velocity,Vector2 direction, float dt){
		velocity.x=(velocity.x + (750.0f*direction.x)*dt)*.95;
		velocity.y=velocity.y + (4200.0f*direction.y)*dt;
		return velocity;
	}
	
	String get_new_animation(bool in){
		String out;
		if(is_on_floor()){
			out=(abs(_velocity.x)>10)?"run":"idle";
		}else{
			out=(_velocity.y>0)?"falling":"jumping";
		}
		if(in){out+="_weapon";}
		return out;
	}
	
	void _init(){}
	void _ready(){
		input=Input::get_singleton();
		sprite=(Sprite*)find_node("Sprite");
		gun=sprite->find_node("Gun");
		animation_player=(AnimationPlayer*)find_node("AnimationPlayer");
		shoot_timer=(Timer*)find_node("ShootAnimation");
	}
	void _physics_process(float dt){
		_velocity.y+=gravity*dt;
		
		timeJump+=dt;
		Vector2 direction=get_direction();
		_velocity=calculate_move_velocity(_velocity,direction,dt);
		_velocity=move_and_slide(_velocity,Vector2(0, -1));
		sprite->set_scale(Vector2(_velocity.x<0?-1.0f:1.0f,1.0f));
		
		bool is_shooting=0;
		if(input->is_action_just_pressed("shoot")){
			Array a;
			a.append(1-((sprite->get_scale().x<0)<<1));
			is_shooting=gun->callv("shoot",a);
		}
		
		String animation=get_new_animation(is_shooting);
		if(!(animation==animation_player->get_current_animation()) && shoot_timer->is_stopped()){
			if(is_shooting){
				shoot_timer->start();
			}
			animation_player->play(animation);
		}
	}
};
}

extern "C" void GDN_EXPORT godot_gdnative_init(godot_gdnative_init_options *o){godot::Godot::gdnative_init(o);}
extern "C" void GDN_EXPORT godot_gdnative_terminate(godot_gdnative_terminate_options *o){godot::Godot::gdnative_terminate(o);}
extern "C" void GDN_EXPORT godot_nativescript_init(void *handle){godot::Godot::nativescript_init(handle);godot::register_class<godot::Player>();}