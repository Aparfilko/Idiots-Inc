extends RichTextLabel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func _process(_delta):
	var quantitty = 0
	#Select World 1
	var world = get_parent().get_node("World 1")
	#Select Child elements 1-6 (trees)
	for n in range (1,7):
		#Checks if the spotlight is on
		if world.get_child(n).get_child(1).visible == true:
			quantitty += 1
	var amount = str(quantitty," selected")
	set("bbcode_text",amount)

