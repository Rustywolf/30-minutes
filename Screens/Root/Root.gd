extends Control
class_name Root

@onready var DialogueScreen = preload("res://Screens/DialogueScreen/DialogueScreen.tscn")
@onready var DeckScreen = preload("res://Screens/DeckScreen/DeckScreen.tscn")
@onready var CombatScreen = preload("res://Screens/CombatScreen/CombatScreen.tscn")
@onready var Inspect := preload("res://Scenes/Inspect/InspectOverlay.tscn")

@onready var current_scene: Control = $MenuScreen

var target_scene: PackedScene = null
var inspect: Control = null
var level: Constants.Level = Constants.Level.INTRO

func _ready():
	randomize()
	Constants.root = self
	

func _transition(new_scene: PackedScene) -> void:
	if target_scene == null:
		target_scene = new_scene
		$AnimationPlayer.play("Transition")
		

func _swap() -> void:
	var idx := current_scene.get_index()
	current_scene.queue_free()
	var new_scene := target_scene.instantiate()
	add_child(new_scene)
	move_child(new_scene, idx)
	current_scene = new_scene
	target_scene = null
	

func transition_from_combat(victory: bool) -> void:
	if victory:
		level += 1
	Constants.game = null
	_transition(DialogueScreen if victory else DeckScreen)
	

func transition_from_main() -> void:
	_transition(DialogueScreen)
	

func transition_from_dialogue() -> void:
	if level == Constants.Level.LEVEL_THREE:
		level = Constants.Level.LEVEL_TWO
		
	if level != Constants.Level.INTRO:
		_transition(DeckScreen)
	else:
		Constants.game = Game.new()
		_transition(CombatScreen)
	

func transition_from_deck() -> void:
	_transition(CombatScreen)
	

func show_inspect_message():
	if inspect != null:
		return
	$InspectMessage.visible = true
	

func hide_inspect_message():
	$InspectMessage.visible = false
	

func show_inspect(model: CardModel):
	if inspect != null:
		return
		
	inspect = Inspect.instantiate()
	add_child(inspect)
	print(inspect)
	inspect.set_model(model)
	

func hide_inspect():
	if inspect == null:
		return
		
	remove_child(inspect)
	inspect.queue_free()
	inspect = null
	

func show_action_message(text: String):
	$ActionMessage.visible = true
	$ActionMessage/Text.text = text
	

func hide_action_message():
	$ActionMessage.visible = false
	
