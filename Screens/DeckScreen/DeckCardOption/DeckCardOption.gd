extends Control


var model: CardModel = null

func _ready():
	_update()
	Deck.connect("updated", _update)
	

func set_model(_model: CardModel) -> void:
	model = _model
	$Card.set_model(model)
	$Shadow1.set_model(model)
	$Shadow2.set_model(model)
	_update()

func _update():
	if not model:
		return
	
	var count := Deck.count(model)
	$Shadow2.visible = count <= 0
	$Shadow1.visible = count <= 1
	$Card.visible = count <= 2


func _on_card_gui_input(event: InputEvent):
	if event.is_action_pressed("Interact"):
		Audio.play_button()
		Deck.add(model)
		if $Card.visible == false:
			Constants.root.hide_inspect_message()
			Constants.root.hide_action_message()
		


func _on_card_mouse_entered():
	Constants.root.show_action_message("Add")
	

func _on_card_mouse_exited():
	Constants.root.hide_action_message()
	
