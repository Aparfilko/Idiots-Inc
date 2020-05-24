extends RichTextLabel
#     List of what the enemies say
var _whattheysay = ["Please dont kill me",
"I dont want to die",
"I'm sorry...",
"Don't shoot!",
"Oh no... It's you!",
"I dont deserve this",
"Hi! What's your name?",
"I don't have any coins",
"Just go away!!!",
"Ugh, What do YOU want?",
"Spare me for Secret Ending",
"Did you see my friends?",
"Are you not entertained?!?",
"I didn't want to fight, but...",
"I hope I respawn too"]

var _textNo
var _txtlength


func _process(_delta):
# warning-ignore:unsafe_property_access
# warning-ignore:unsafe_property_access
#             finds distance to player 
	var distance2Hero = get_parent().get_parent().global_position.distance_to(get_parent().get_parent().get_parent().get_parent().get_node("Player").global_position)
	if(distance2Hero < 150):
# warning-ignore:unsafe_property_access
		get_parent().visible = true
	else:
# warning-ignore:unsafe_property_access
		get_parent().visible = false
	#         if the player is nearby, show message
	

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	#   we need randomize() to make randi() actually random
# warning-ignore:integer_division
	_textNo = randi()/100%_whattheysay.size()
	set_bbcode(_whattheysay[_textNo])
	set_visible_characters(-1)
	#set_visible_characters(0)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

#This should have made the text appear gradually
#func _on_Timer_timeout():
	#set_visible_characters(get_visible_characters()+1)
	#if !get_visible_characters() == _txtlength:
		#Timer.start()
