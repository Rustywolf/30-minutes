extends Node

enum Level {
	INTRO = 0,
	LEVEL_ONE = 1,
	LEVEL_TWO = 2,
	LEVEL_THREE = 3,
}

enum CardType {
	ATTACK,
	DEFENSE,
	UTILITY
}

var root: Root = null
var game: Game = null
