extends Node


var INTRO: Array[String] = [
	"Dear Wizard,",
	"You have been summoned by\nHis Majesty The King to concoct a potion.",
	"Included with this letter are a vial brimming with [color=#eeb4eb]holy water[/color] and these instructions.",
	"First, you will need the [color=#eeb4eb]antler of a Jackalope[/color]...",
]

var LEVEL_ONE: Array[String] = [
	"Powder the antler and mix it with the holy water.",
	"Next, obtain a [color=#eeb4eb]Phoenix feather[/color]...",
]

var LEVEL_TWO: Array[String] = [
	"Insert the feather into the vial and swirl until fully dissolved.",
	"Then [color=#eeb4eb]deliver[/color] the potion to the King's personal chamber.",
	"I would tread carefully, as he has a bit of a temper...",
]

var LEVEL_THREE: Array[String] = [
	"Thank you for the potion delivery,\nand [color=#eeb4eb]thank you[/color] for playing.",
	"The King may need another dose, if you're feeling up to it...",
]

var all := [
	INTRO,
	LEVEL_ONE,
	LEVEL_TWO,
	LEVEL_THREE
]
