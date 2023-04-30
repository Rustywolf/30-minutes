extends Control
signal pressed

@export var text := ""
@export var enabled := false : set = _set_enabled

func _ready():
	$CenterContainer/Text.text = "[center]%s" % text
	_update()
	

func _update():
	$Hover.visible = false
	if enabled:
		$On.visible = true
		$Off.visible = false
	else:
		$On.visible = false
		$Off.visible = true
	

func _set_enabled(value):
	enabled = value
	_update()
	

func _on_mouse_entered():
	if enabled:
		$On.visible = false
		$Hover.visible = true
	

func _on_mouse_exited():
	if enabled:
		$On.visible = true
		$Hover.visible = false
	

func _on_gui_input(event: InputEvent):
	if event.is_action_pressed("Interact") and enabled:
		emit_signal("pressed")
		Audio.play_button()
		
