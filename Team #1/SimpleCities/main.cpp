#include <Godot.hpp>
#include <Spatial.hpp>
#include <Input.hpp>
#include <InputEvent.hpp>
#include <Vector3.hpp>
#include <Camera.hpp>
#include <MeshInstance.hpp>
#include <CubeMesh.hpp>
#include <SpatialMaterial.hpp>
#include <ResourceLoader.hpp>
#include <PackedScene.hpp>
#include <Ref.hpp>
#include <RandomNumberGenerator.hpp>

#include <vector>

#define DIM 5
#define MATSNUM 7
#define CUBESNUM 7

namespace godot{
class GDMain:public Spatial{
	GODOT_CLASS(GDMain,Spatial)
	
	typedef struct {char type,color;}mapTile;
	typedef struct {int x,y;} carPathNode;
	typedef struct {char color;std::vector<carPathNode> p;} carPath;
	typedef struct {int steps;carPathNode from;} bfsNode;
	typedef struct {
		int dir;
		int pathInd;
		float time;
		MeshInstance* mesh;
		int timeInd;
		carPathNode to,from;
		Vector3 offset;
		float rot;
	} car;
	typedef struct {int x,y,type,color;MeshInstance* b;} building;
	
	SpatialMaterial* mats[MATSNUM];//gray,red,orange,yellow,green,blue,purple
	CubeMesh* cubes[CUBESNUM];//road,cars(1-7)
	
	RandomNumberGenerator* rng;
	ResourceLoader* rl;
	Ref<PackedScene> foundationPacked;
	Ref<PackedScene> housePacked;
	Ref<PackedScene> officePacked;
	Input* input;
	Camera* cam;
	std::vector<Spatial*> foundations;
	std::vector<building> buildings;
	std::vector<MeshInstance*> roads;
	int xDim,yDim;
	std::vector<mapTile> lvl;
	std::vector<carPath> paths;
	std::vector<car> cars;
	
	void removeBuilding(int x,int y){
	}
	
	void addBuilding(int x,int y,int c,int type){
		buildings.push_back(building());
		if(type==2){
			buildings.back().b=(MeshInstance*)housePacked->instance();
			buildings.back().b->set_translation(Vector3(x,.4,y));
		}else if(type==3){
			buildings.back().b=(MeshInstance*)officePacked->instance();
			buildings.back().b->set_translation(Vector3(x,1.2,y));
		}
		buildings.back().b->set_surface_material(0,mats[c]);
		buildings.back().b->set_rotation(Vector3(0,-1.57,0));
		add_child(buildings.back().b);
		buildings.back().type=lvl[xDim*y+x].type=type;
		buildings.back().color=lvl[xDim*y+x].color=c;
		buildings.back().x=x;buildings.back().y=y;
	}
	
	void addRoad(int x,int y){
		if(!lvl[xDim*y+x].color){
			roads.push_back(MeshInstance::_new());
			roads.back()->set_mesh(cubes[0]);
			roads.back()->set_translation(Vector3(x,0,y));
			add_child(roads.back());
			lvl[xDim*y+x].color=1;
		}
	}
	void addRoadConnector(float x,float y){
		roads.push_back(MeshInstance::_new());
		roads.back()->set_mesh(cubes[0]);
		roads.back()->set_translation(Vector3(x,0,y));
		add_child(roads.back());
	}
	
	void bfs(int x0,int y0,int x1,int y1,int c){
		std::vector<bfsNode> map(xDim*yDim);
		for(int i=0;i<map.size();i++){map[i]={0,{0,0}};}
		std::vector<carPathNode> frontier;
		frontier.push_back({x0,y0});
		map[xDim*y0+x0].steps=1;
		while(!frontier.empty()){
			carPathNode curr=frontier[0];
			frontier.erase(frontier.begin());
			if(curr.x==x1&&curr.y==y1){
				paths.push_back(carPath());
				paths.back().color=c;
				paths.back().p.push_back({x1,y1});
				while(!(paths.back().p.back().x==x0 && paths.back().p.back().y==y0)){
					paths.back().p.push_back(map[xDim*paths.back().p.back().y+paths.back().p.back().x].from);
				}
				return;
			}
			
			if(curr.x>0&&(lvl[xDim*curr.y+curr.x-1].type==1||(curr.y==y1&&curr.x-1==x1))&&(!map[xDim*curr.y+curr.x-1].steps||map[xDim*curr.y+curr.x-1].steps>map[xDim*curr.y+curr.x].steps+1)){
				map[xDim*curr.y+curr.x-1]={map[xDim*curr.y+curr.x].steps+1,curr};
				frontier.push_back({curr.x-1,curr.y});
			}
			if(curr.x+1<xDim&&(lvl[xDim*curr.y+curr.x+1].type==1||(curr.y==y1&&curr.x+1==x1))&&(!map[xDim*curr.y+curr.x+1].steps||map[xDim*curr.y+curr.x+1].steps>map[xDim*curr.y+curr.x].steps+1)){
				map[xDim*curr.y+curr.x+1]={map[xDim*curr.y+curr.x].steps+1,curr};
				frontier.push_back({curr.x+1,curr.y});
			}
			if(curr.y>0&&(lvl[xDim*(curr.y-1)+curr.x].type==1||(curr.y-1==y1&&curr.x==x1))&&(!map[xDim*(curr.y-1)+curr.x].steps||map[xDim*(curr.y-1)+curr.x].steps>map[xDim*curr.y+curr.x].steps+1)){
				map[xDim*(curr.y-1)+curr.x]={map[xDim*curr.y+curr.x].steps+1,curr};
				frontier.push_back({curr.x,curr.y-1});
			}
			if(curr.y+1<yDim&&(lvl[xDim*(curr.y+1)+curr.x].type==1||(curr.y+1==y1&&curr.x==x1))&&(!map[xDim*(curr.y+1)+curr.x].steps||map[xDim*(curr.y+1)+curr.x].steps>map[xDim*curr.y+curr.x].steps+1)){
				map[xDim*(curr.y+1)+curr.x]={map[xDim*curr.y+curr.x].steps+1,curr};
				frontier.push_back({curr.x,curr.y+1});
			}
		}
	}
	
	void populateRoads(){
		for(int y0=0;y0<yDim;y0++){
			for(int x0=0;x0<xDim;x0++){
				if(lvl[xDim*y0+x0].type==3){
					for(int y1=0;y1<yDim;y1++){
						for(int x1=0;x1<xDim;x1++){
							if((y0+y1<yDim && x0+x1<xDim) && lvl[xDim*(y0+y1)+x0+x1].type==2 && lvl[xDim*(y0+y1)+x0+x1].color==lvl[xDim*y0+x0].color){
								bfs(x0,y0,x0+x1,y0+y1,lvl[xDim*y0+x0].color);
							}
							if((y1 && y0-y1>=0 && x0+x1<xDim) && lvl[xDim*(y0-y1)+x0+x1].type==2 && lvl[xDim*(y0-y1)+x0+x1].color==lvl[xDim*y0+x0].color){
								bfs(x0,y0,x0+x1,y0-y1,lvl[xDim*y0+x0].color);
							}
							if((x1 && y0+y1<yDim && x0-x1>=0) && lvl[xDim*(y0+y1)+x0-x1].type==2 && lvl[xDim*(y0+y1)+x0-x1].color==lvl[xDim*y0+x0].color){
								bfs(x0,y0,x0-x1,y0+y1,lvl[xDim*y0+x0].color);
							}
							if((y1&&x1 && y0-y1>=0 && x0-x1>=0) && lvl[xDim*(y0-y1)+x0-x1].type==2 && lvl[xDim*(y0-y1)+x0-x1].color==lvl[xDim*y0+x0].color){
								bfs(x0,y0,x0-x1,y0-y1,lvl[xDim*y0+x0].color);
							}
						}
					}
				}
			}
		}
	}
	
	void placeRoads(){
		for(carPath &p:paths){
			for(carPathNode &n:p.p){
				addRoad(n.x,n.y);
			}
		}
		for(int y=0;y<yDim;y++){
			for(int x=0;x<xDim-1;x++){
				if(
				(lvl[y*xDim+x].type>1||(lvl[y*xDim+x].type==1&&lvl[y*xDim+x].color))&&
				(lvl[y*xDim+x+1].type>1||(lvl[y*xDim+x+1].type==1&&lvl[y*xDim+x+1].color))){
					addRoadConnector(x+.5,y);
				}
			}
		}
		for(int y=0;y<yDim-1;y++){
			for(int x=0;x<xDim;x++){
				if(
				(lvl[y*xDim+x].type>1||(lvl[y*xDim+x].type==1&&lvl[y*xDim+x].color))&&
				(lvl[(y+1)*xDim+x].type>1||(lvl[(y+1)*xDim+x].type==1&&lvl[(y+1)*xDim+x].color))){
					addRoadConnector(x,y+.5);
				}
			}
		}
	}
	
	public:
	GDMain(){}
	~GDMain(){}

	void _init(){
		rng=RandomNumberGenerator::_new();
		
		rl=ResourceLoader::get_singleton();
		foundationPacked=rl->load("res://foundation.tscn");
		housePacked=rl->load("res://house.tscn");
		officePacked=rl->load("res://office.tscn");
		
		input=Input::get_singleton();
		add_child(cam=Camera::_new());
		cam->set_rotation(Vector3(-1.2,0,0));
		
		{
		for(int i=0;i<MATSNUM;i++){mats[i]=SpatialMaterial::_new();}
		mats[0]->set_albedo(Color(.5,.5,.5));
		mats[1]->set_albedo(Color(1,.5,.5));
		mats[2]->set_albedo(Color(1,.5,.3));
		mats[3]->set_albedo(Color(1,.7,.3));
		mats[4]->set_albedo(Color(.5,.8,.5));
		mats[5]->set_albedo(Color(.5,.5,.8));
		mats[6]->set_albedo(Color(.7,.5,.7));
		}{
		for(int i=0;i<CUBESNUM;i++){cubes[i]=CubeMesh::_new();}
		cubes[0]->set_size(Vector3(.5,.05,.5));
		cubes[0]->set_material(mats[0]);
		for(int i=1;i<CUBESNUM;i++){
			cubes[i]->set_size(Vector3(.2,.15,.4));
			cubes[i]->set_material(mats[i]);
		}
		}
		
		FILE* fid=fopen("lvl1.cty","r");
		char line[256];
		fgets(line,256,fid);
		sscanf(line,"%d%d",&xDim,&yDim);
		cam->set_translation(Vector3(xDim,10,yDim));
		fgets(line,256,fid);
		sscanf(line,"%d%d",&xDim,&yDim);
		lvl.resize(xDim*yDim);
		for(int i=0;i<lvl.size();i++){lvl[i]={0,0};}
		while(fgets(line,256,fid)){
			if(line[0]=='\n'||line[0]=='#'){continue;}
			if(line[0]=='='){break;}
			int a,b,c,d;
			int e=sscanf(line,"%d%d%d%d",&a,&b,&c,&d);
			if(e<2){continue;}
			if(e<4){c=a;d=b;}
			
			for(int y=b;y<=d;y++){
				for(int x=a;x<=c;x++){if(!lvl[y*xDim+x].type){
					lvl[y*xDim+x].type=1;
					foundations.push_back((Spatial*)foundationPacked->instance());
					foundations.back()->set_translation(Vector3(x,0,y));
					add_child(foundations.back());
				}}
			}
		}
		fclose(fid);
		
		addBuilding(1,1,1,3);
		addBuilding(12,6,4,3);
		addBuilding(7,13,5,3);
		
		addBuilding(18,15,1,2);
		addBuilding(18,16,1,2);
		addBuilding(18,17,1,2);
		addBuilding(18,18,1,2);
		
		addBuilding(5,1,4,2);
		addBuilding(5,2,4,2);
		addBuilding(5,3,4,2);
		addBuilding(5,4,1,2);
		
		addBuilding(10,5,1,2);
		addBuilding(10,6,1,2);
		addBuilding(9,5,4,2);
		addBuilding(9,6,4,2);
		
		addBuilding(10,9,5,2);
		addBuilding(10,10,5,2);
		addBuilding(9,9,1,2);
		addBuilding(9,10,1,2);
		
		populateRoads();
		placeRoads();
		for(int i=0;i<paths.size();i++){
			cars.push_back(car());
			add_child(cars.back().mesh=MeshInstance::_new());
			cars.back().mesh->set_mesh(cubes[paths[i].color]);
			cars.back().pathInd=i;
			cars.back().timeInd=-1;
			cars.back().dir=0;
			cars.back().time=rng->randf_range(1,10);
			cars.back().mesh->set_translation(Vector3(paths[cars.back().pathInd].p[0].x,0,paths[cars.back().pathInd].p[0].y));
		}
	}
	
	void _input(InputEvent* in){
		if(in->is_action_pressed("w")){cam->set_translation(cam->get_translation()+Vector3(0,0,-1));}
		if(in->is_action_pressed("a")){cam->set_translation(cam->get_translation()+Vector3(-1,0,0));}
		if(in->is_action_pressed("s")){cam->set_translation(cam->get_translation()+Vector3(0,0,1));}
		if(in->is_action_pressed("d")){cam->set_translation(cam->get_translation()+Vector3(1,0,0));}
	}
	
	void _process(float dt){
		for(car &c:cars){
			c.time-=dt;
			if(c.dir==0){//atHouse
				if(c.time<=0){c.dir=1;c.time=paths[c.pathInd].p.size()-1;}
			}else if(c.dir==1){//drivingToOffice
				float t=paths[c.pathInd].p.size()-1-c.time;
				if((int)t!=c.timeInd){
					c.timeInd=(int)t;
					c.from=paths[c.pathInd].p[t];
					c.to=paths[c.pathInd].p[t+1];
					if(c.to.x>c.from.x){c.rot=4.71;c.offset=Vector3(0,0,.12);}else
					if(c.to.y<c.from.y){c.rot=0.00;c.offset=Vector3(.12,0,0);}else
					if(c.to.x<c.from.x){c.rot=1.57;c.offset=Vector3(0,0,-.12);}else
					if(c.to.y>c.from.y){c.rot=3.14;c.offset=Vector3(-.12,0,0);}
				}
				float rat=fmod(t,1.0);
				c.mesh->set_translation(Vector3(c.from.x,0,c.from.y)*(1.0-rat)+Vector3(c.to.x,0,c.to.y)*(rat)+c.offset);
				c.mesh->set_rotation(Vector3(0,c.rot,0));
				if(c.time<=0){
					c.dir=2;c.time=rng->randf_range(1,10);c.timeInd=-1;
					c.mesh->set_translation(Vector3(paths[c.pathInd].p.back().x,0,paths[c.pathInd].p.back().y));
				}
			}else if(c.dir==2){//atOffice
				if(c.time<=0){c.dir=3;c.time=paths[c.pathInd].p.size()-1;}
			}else if(c.dir==3){//drivingToHouse
				float t=c.time;
				if((int)t!=c.timeInd){
					c.timeInd=(int)t;
					c.from=paths[c.pathInd].p[t+1];
					c.to=paths[c.pathInd].p[t];
					if(c.to.x>c.from.x){c.rot=4.71;c.offset=Vector3(0,0,.12);}else
					if(c.to.y<c.from.y){c.rot=0.00;c.offset=Vector3(.12,0,0);}else
					if(c.to.x<c.from.x){c.rot=1.57;c.offset=Vector3(0,0,-.12);}else
					if(c.to.y>c.from.y){c.rot=3.14;c.offset=Vector3(-.12,0,0);}
				}
				float rat=fmod(t,1.0);
				c.mesh->set_translation(Vector3(c.from.x,0,c.from.y)*(rat)+Vector3(c.to.x,0,c.to.y)*(1.0-rat)+c.offset);
				c.mesh->set_rotation(Vector3(0,c.rot,0));
				if(c.time<=0){
					c.dir=0;c.time=rng->randf_range(1,10);c.timeInd=-1;
					c.mesh->set_translation(Vector3(paths[c.pathInd].p[0].x,0,paths[c.pathInd].p[0].y));
				}
			}
		}
	}
	
	void _foundation_place_building(int x,int y,int color,int type){
		addBuilding(x,y,color,type);
	}

	static void _register_methods(){
		register_method("_input",&GDMain::_input);
		register_method("_process",&GDMain::_process);
		register_method("_foundation_place_building",&GDMain::_foundation_place_building);
	}
};
}

extern "C" void GDN_EXPORT godot_gdnative_init(godot_gdnative_init_options *o){godot::Godot::gdnative_init(o);}
extern "C" void GDN_EXPORT godot_gdnative_terminate(godot_gdnative_terminate_options *o){godot::Godot::gdnative_terminate(o);}
extern "C" void GDN_EXPORT godot_nativescript_init(void *p){godot::Godot::nativescript_init(p);godot::register_class<godot::GDMain>();}