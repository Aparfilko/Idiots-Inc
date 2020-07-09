extends Node2D


#save level data to the user's computer to keep unlocked levels
func save(content):
	var file = File.new()
	file.open("user://save_game.dat", File.WRITE)
	file.store_string(content)
	file.close()
func load():
	var file = File.new()
	file.open("user://save_game.dat", File.READ)
	var content = file.get_as_text()
	file.close()
	return content

var flipper = 1
var doaflip = false
var dx = -0.05
var gotoMain= false
var num

func goToLevel(num):
	$musicManager.chooseMusic(num)
	var scene = load("res://Levels/Level"+ num + ".tscn")
	var node = scene.instance()
	add_child(node)
	get_node("Level/Camera2D/User Interface").connect("resize", self, "resizing")
	
#just in case
func resizing():
	pass

func _on_Back_pressed():
	pass
	#get_parent().get_child(0).offset.y=0
	#get_tree().change_scene('res://Title.tscn')

func choose_level(i):
	num=num+i
	goToLevel(num)
