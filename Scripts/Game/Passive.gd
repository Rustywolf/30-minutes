extends Node
class_name Passive

var title := ""
var art: Texture2D = null
var desc := ""

func _init(_title: String, _art: Texture2D, _desc: String):
	title = _title
	art = _art
	desc = _desc
	
