extends Node
class_name CardModel

var title := ""
var cost := 0
var type: Constants.CardType = Constants.CardType.ATTACK
var art: Texture2D = null
var desc: Callable = func(): return ""
var run: Callable = func(): pass


func _init(_title: String, _cost: int, _type: Constants.CardType, _art: Texture2D, _desc: Callable, _run: Callable):
	title = _title
	cost = _cost
	type = _type
	art = _art
	desc = _desc
	run = _run
	

func get_desc():
	return desc.call(ModelHelper.new(Constants.game))
	

func play(game: Game):
	run.call(game)
	

class ModelHelper:
	var game: Game = null
	
	func _init(_game: Game):
		game = _game
		
	
	func damage(amount, raw=false):
		if not raw and game:
			amount = game.calculate_player_damage(amount)
		return "[color=#eea5b2]%s[/color]" % amount
		
	
	func mana(amount):
		return "[color=#8feeeb]%s[/color]" % amount
		
	
	func block(amount):
		return "[color=#aae96c]%s[/color]" % amount
		
	
	func highlight(text):
		return "[color=#eeb4eb]%s[/color]" % text
