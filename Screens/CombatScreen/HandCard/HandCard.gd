extends Control

var tween: Tween = null
var model: CardModel = null

func set_model(_model: CardModel) -> void:
	model = _model
	$Card.set_model(model)
	

func _on_card_mouse_entered():
	Constants.root.show_action_message("Play")
	if tween:
		tween.kill()
	tween = get_tree().create_tween().bind_node(self)
	tween.tween_property($Card, "position", Vector2(-75, -755), 0.3).set_trans(Tween.TRANS_BACK)
	z_index = 1


func _on_card_mouse_exited():
	Constants.root.hide_action_message()
	if tween:
		tween.kill()
	tween = get_tree().create_tween().bind_node(self)
	tween.tween_property($Card, "position", Vector2(-75, -705), 0.3).set_trans(Tween.TRANS_SINE)
	z_index = 0
	

func _on_card_gui_input(event: InputEvent):
	if event.is_action_pressed("Interact"):
		if Constants.game.play(get_index()):
			Audio.play_play()
		
