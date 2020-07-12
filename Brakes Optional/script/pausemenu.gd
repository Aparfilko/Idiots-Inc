extends Control


# Declare member variables here. Examples:
# var a = 2
var pauseState = false
var halt
onready var screenInit = Vector2(1920, 1080)


# Called when the node enters the scene tree for the first time.
func _ready():
	halt = false
	visible = pauseState
	get_tree().paused = pauseState
	resize()
	
func resize():
	var x = OS.get_window_size().x/screenInit.x
	var y = OS.get_window_size().y/screenInit.y
	set_scale(Vector2(x, y))
	
func _input(event):
	if event.is_action_pressed("ui_cancel") and not halt:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		pauseState = not pauseState
		visible = not visible
		get_tree().paused = pauseState

func _on_Resume_pressed(): #resume
	pauseState = false
	visible = pauseState
	get_tree().paused = pauseState

func _on_Restart_pressed(): #restart track
	pauseState = false
	visible = pauseState
	get_tree().paused = pauseState
	var levelMan = get_parent().get_parent().get_node("ManagerLevel")
	levelMan.emit_signal("reset")
	levelMan.refCar.transform=levelMan.refCurr.get_node("SpawnPoint").transform;

func _on_BackToStart_pressed(): #Return to either start screen or whatever main 
	get_tree().change_scene("res://overlay/TitleScreen.tscn")

func _on_Quit_pressed(): #quit game. no dialogue to confirm that yet.
	get_tree().quit();
