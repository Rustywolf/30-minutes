extends Control

@onready var DeckCardSelection := preload("res://Screens/DeckScreen/DeckCardSelection/DeckCardSelection.tscn")

func _ready():
	for i in range($Options.get_child_count()):
		var child := $Options.get_child(i)
		var model := CardModels.all[i]
		child.set_model(model)
		
	_update()
	Deck.connect("updated", _update)
	

func _update():
	for child in $Selected.get_children():
		child.queue_free()
		
	for i in range(len(Deck.deck)):
		var child := DeckCardSelection.instantiate()
		$Selected.add_child(child)
		var model := Deck.deck[i]
		child.set_model(model)
		
	$RoundButton.enabled = Deck.valid()
	

func _process(delta):
	pass


func _on_round_button_pressed():
	Constants.game = Game.new()
	Constants.root.transition_from_deck()
	
