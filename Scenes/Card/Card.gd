extends Control

@onready var frame = $Frame
@onready var art = $Art
@onready var cost = $Cost
@onready var title = $Title
@onready var desc = $CenterContainer/Description

var model: CardModel = null

func _ready():
	if Constants.game != null:
		Constants.game.connect("player_passives_updated", _update)
		Constants.game.connect("enemy_passives_updated", _update)
		

func set_model(_model: CardModel) -> void:
	model = _model
	_update()
	

func _update() -> void:
	art.texture = model.art
	cost.text = "%s" % model.cost
	title.text = "[center]%s" % model.title
	desc.text = "[center]%s" % model.get_desc()
	match model.type:
		Constants.CardType.ATTACK:
			frame.texture = Art.FrameAttack
		Constants.CardType.DEFENSE:
			frame.texture = Art.FrameDefense
		Constants.CardType.UTILITY:
			frame.texture = Art.FrameUtility
		

func _on_mouse_entered():
	get_tree().get_root().get_node("./Root").show_inspect_message()
	

func _on_mouse_exited():
	get_tree().get_root().get_node("./Root").hide_inspect_message()
	

func _on_gui_input(event: InputEvent):
	if event.is_action_pressed("Inspect"):
		Audio.play_button()
		get_tree().get_root().get_node("./Root").show_inspect(model)
		
