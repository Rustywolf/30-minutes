extends Control

var model: CardModel = null


func _ready():
	Constants.root.hide_action_message()
	Constants.root.hide_inspect_message()
	

func set_model(_model: CardModel) -> void:
	model = _model
	$Card.set_model(model)
	

func _on_color_rect_gui_input(event: InputEvent):
	if event.is_action_pressed("Interact"):
		Audio.play_button()
		Constants.root.hide_inspect()
	
