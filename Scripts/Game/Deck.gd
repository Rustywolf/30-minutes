extends Node
signal updated

var deck: Array[CardModel] = []

func _ready():
	deck = [
		CardModels.fire_strike,
		CardModels.fire_strike,
		CardModels.fire_strike,
		CardModels.ice_wall,
		CardModels.ice_wall,
		CardModels.ice_wall,
		CardModels.wall_of_force,
		CardModels.channel,
		CardModels.channel,
	]
	emit_signal("updated")
	

func count(model: CardModel) -> int:
	var res := 0
	for card in deck:
		if card.title == model.title:
			res += 1
	return res
	

func valid() -> bool:
	return len(deck) == 9
	

func remove(model: CardModel) -> void:
	var idx := deck.find(model)
	if idx != -1:
		deck.remove_at(idx)
		emit_signal("updated")
		

func add(model: CardModel) -> void:
	var amt := count(model)
	if amt >= 3 || len(deck) >= 9:
		return
	
	deck.push_back(model)
	emit_signal("updated")
	
