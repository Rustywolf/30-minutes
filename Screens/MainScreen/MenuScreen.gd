extends Control

@onready var dialogue_scene := preload("res://Screens/DialogueScreen/DialogueScreen.tscn")

var total := 0.0


func _on_round_button_pressed():
	Constants.root.transition_from_main()
	

func _process(delta):
	total += delta
	$TextureRect.scale = Vector2(1 + 0.05 * sin(total * 2), 1 + 0.05 * sin(total * 2))
	
