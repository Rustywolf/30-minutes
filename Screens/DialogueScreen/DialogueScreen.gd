extends Control


var idx := 0
var dialogue: Array[String] = []

func _ready():
	idx = 0
	dialogue = Dialogue.all[Constants.root.level]
	_update()
	

func _update():
	$Text.text = dialogue[idx]
	

func _on_color_rect_gui_input(event: InputEvent):
	if event.is_action_pressed("Interact"):
		Audio.play_textbox()
		idx += 1
		if idx >= len(dialogue):
			Constants.root.transition_from_dialogue()
		else:
			_update()
		
