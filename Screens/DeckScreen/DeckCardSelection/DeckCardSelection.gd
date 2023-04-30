extends Control


var model: CardModel = null

func set_model(_model: CardModel) -> void:
	model = _model
	$Card.set_model(model)
	

func _on_card_gui_input(event: InputEvent):
	if event.is_action_pressed("Interact"):
		Audio.play_button()
		Deck.remove(model)
		Constants.root.hide_action_message()
		Constants.root.hide_inspect_message()
		


func _on_card_mouse_entered():
	Constants.root.show_action_message("Remove")
	

func _on_card_mouse_exited():
	Constants.root.hide_action_message()
	
