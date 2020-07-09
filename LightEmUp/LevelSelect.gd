extends Node2D
var flipper = 1
var doaflip = false
var dx = -0.05
var gotoMain= false

func goToLevel(num):
	$musicManager.chooseMusic(num)
	var scene = load("res://Levels/Level"+ num + ".tscn")
	var node = scene.instance()
	add_child(node)
	get_node("Level/Camera2D/User Interface").connect("resize", self, "resizing")
	
#just in case
func resizing():
	pass
#
#func _on_1_pressed():
#	get_tree().change_scene("res://Levels/Level1.tscn")
#
##func _on_2_pressed():
#	get_tree().change_scene('res://Levels/Level2.tscn')
#
#func _on_3_pressed():
#	get_tree().change_scene('res://Levels/3.tscn')
#
#func _on_4_pressed():
#	get_tree().change_scene('res://Levels/4.tscn')
#
#func _on_5_pressed():
#	get_tree().change_scene('res://Levels/5.tscn')
#
#func _on_6_pressed():
#	get_tree().change_scene('res://Levels/6.tscn')
#
#func _on_7_pressed():
#	get_tree().change_scene('res://Levels/7.tscn')
#
#func _on_8_pressed():
#	get_tree().change_scene('res://Levels/8.tscn')
#
#func _on_9_pressed():
#	get_tree().change_scene('res://Levels/9.tscn')
#
#func _on_10_pressed():
#	get_tree().change_scene('res://Levels/10.tscn')
#
#func _on_11_pressed():
#	get_tree().change_scene('res://Levels/11.tscn')
#
#func _on_12_pressed():
#	get_tree().change_scene('res://Levels/12.tscn')
#
#func _on_13_pressed():
#	get_tree().change_scene('res://Levels/13.tscn')
#
#func _on_14_pressed():
#	get_tree().change_scene('res://Levels/14.tscn')
#
#func _on_15_pressed():
#	get_tree().change_scene('res://Levels/15.tscn')

func _on_Back_pressed():
	pass
	#get_parent().get_child(0).offset.y=0
	#get_tree().change_scene('res://Title.tscn')

