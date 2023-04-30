extends Control

@onready var HandCard = preload("res://Screens/CombatScreen/HandCard/HandCard.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	_update()
	Constants.game.connect("hand_updated", _update)


func _update():
	if not Constants.game:
		return
		
	for child in $Cards.get_children():
		child.queue_free()
		
	var count := len(Constants.game.hand)
	var angle_min := -2.5 * (count - 1)
	var angle_max := -angle_min
	
	for i in range(count):
		var card := Constants.game.hand[i]
		var hand_card := HandCard.instantiate()
		$Cards.add_child(hand_card)
		hand_card.set_model(card)
		hand_card.position.y = 600
		hand_card.rotation_degrees = 0 if count == 1 else lerp(angle_min, angle_max, float(i) / float(count - 1))
	
