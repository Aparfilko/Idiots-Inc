extends PopupDialog


var refManagerLevel

func _on_Next_pressed():
#	set_ManagerLevel()
	pass

func _on_Quit_pressed():
	get_tree().quit()

func set_ManagerLevel(i):
	refManagerLevel = i
