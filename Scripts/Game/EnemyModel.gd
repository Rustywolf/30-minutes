extends Node
class_name EnemyModel

var title := ""
var max_hp := 100
var art: Texture2D = null
var desc: Array[Callable] = []
var run: Array[Callable] = []


func _init(_title: String, _max_hp: int, _art: Texture2D):
	title = _title
	max_hp = _max_hp
	art = _art
	desc = []
	run = []
	

func get_desc(phase: int):
	return desc[phase].call(ModelHelper.new(Constants.game))
	

func play(phase: int, game: Game):
	run[phase].call(game)
	

func add_action(_desc: Callable, _run: Callable) -> EnemyModel:
	desc.push_back(_desc)
	run.push_back(_run)
	return self
	

class ModelHelper:
	var game: Game = null
	
	func _init(_game: Game):
		game = _game
		
	
	func damage(amount, raw=false):
		if not raw and game:
			amount = game.calculate_enemy_damage(amount)
		return "[color=#eea5b2]%s[/color]" % amount
		
	
	func mana(amount):
		return "[color=#8feeeb]%s[/color]" % amount
		
	
	func block(amount):
		return "[color=#aae96c]%s[/color]" % amount
		
	
	func highlight(text):
		return "[color=#eeb4eb]%s[/color]" % text
