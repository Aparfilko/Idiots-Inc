extends Node2D

var flipper = 1
var doaflip = false
var dx = -0.05
var gotoLevelSelect= false
var offset
func _ready():
	$LevelSelect/musicManager/title.play()

func _on_Level_Select_pressed():
	gotoLevelSelect = true
	offset = 1000
	#get_child(0).offset.y =1000
	#get_tree().change_scene('res://LevelSelect.tscn')

func _on_Quit_pressed():
	get_tree().quit()

func _on_Back_pressed():
	gotoLevelSelect = true
	offset = 0
	
func _process(_delta):
	#this part makes the screen flip
	#makes variable flipper go from 1 to 0 to 1
	if gotoLevelSelect:
		get_child(3).visible = false
		gotoLevelSelect = false
		doaflip = true
	if doaflip == true:
		flipper += dx
	if flipper <= 0:
		dx = 0.05
		get_child(0).offset.y = offset
	if flipper == 1:
		get_child(3).visible = true
		doaflip = false
		dx = -0.05
	#scales both menu's x by flipper
	get_child(2).rect_scale.x = flipper
	get_child(1).get_child(0).rect_scale.x = flipper
