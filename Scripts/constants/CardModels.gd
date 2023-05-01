extends Node

@onready var fire_strike := CardModel.new(
	"Fire Strike", 1, Constants.CardType.ATTACK, Art.FireStrike, 
	func(helper): 
		return "Deal %s damage.\nGain %s mana." % [helper.damage(4), helper.mana(2)],
	func(game: Game):
		game.hit_enemy(4)
		game.player_gain_mana(2)
)

@onready var ice_wall := CardModel.new(
	"Ice Wall", 1, Constants.CardType.DEFENSE, Art.IceWall, 
	func(helper): 
		return "Gain %s block.\nGain %s mana." % [helper.block(5), helper.mana(1)],
	func(game: Game):
		game.player_gain_block(5)
		game.player_gain_mana(1)
)

@onready var air_slash := CardModel.new(
	"Air Slash", 1, Constants.CardType.ATTACK, Art.AirSlash, 
	func(helper): 
		return "Deal %s damage, then spend %s mana to gain block for the damage dealt." % [helper.damage(2), helper.mana(1)],
	func(game: Game):
		game.hit_enemy(2)
		if game.player_spend_mana(1):
			var amt := game.calculate_player_damage(2)
			game.player_gain_block(amt)
)

@onready var meteor_strike := CardModel.new(
	"Meteor Strike", 2, Constants.CardType.ATTACK, Art.MeteorStrike, 
	func(helper): 
		return "Deal %s damage.\nSpend %s mana to double it." % [helper.damage(10), helper.mana(5)],
	func(game: Game):
		var dmg := 10
		if game.player_spend_mana(5):
			dmg *= 2
		game.hit_enemy(dmg)
)

@onready var zone_of_intellect := CardModel.new(
	"Zone of Intellect", 1, Constants.CardType.UTILITY, Art.ZoneOfInt, 
	func(helper): 
		return "All future damage is increased by %s." % [helper.damage(1, true)],
	func(game: Game):
		game.player_add_passive(Passives.IncreaseDamage)
)

@onready var wall_of_force := CardModel.new(
	"Wall of Force", 2, Constants.CardType.DEFENSE, Art.WallOfForce, 
	func(helper): 
		return "Halve all damage this turn. Spend %s mana to gain %s block." % [helper.mana(3), helper.block(5)],
	func(game: Game):
		game.player_add_passive(Passives.HalveDamage)
		if game.player_spend_mana(3):
			game.player_gain_block(5)
)

@onready var channel := CardModel.new(
	"Channel", 1, Constants.CardType.UTILITY, Art.Channel, 
	func(helper): 
		return "Gain %s mana.\nDraw a card." % [helper.mana(2)],
	func(game: Game):
		game.player_gain_mana(2)
		game.draw(1)
)

@onready var arcane_shell := CardModel.new(
	"Arcane Shell", 1, Constants.CardType.DEFENSE, Art.ArcaneShell, 
	func(helper): 
		return "Spend all mana.\nGain %s block for each mana spent." % [helper.block(3)],
	func(game: Game):
		var mana := game.player_mana
		if game.player_spend_mana(mana):
			game.player_gain_block(mana * 3)
)

@onready var research := CardModel.new(
	"Research", 0, Constants.CardType.UTILITY, Art.Research, 
	func(helper): 
		return "Spend %s mana to\ndraw %s cards." % [helper.mana(4), helper.highlight(2)],
	func(game: Game):
		if game.player_spend_mana(4):
			game.draw(2)
)

@onready var preparation := CardModel.new(
	"Preparation", 2, Constants.CardType.UTILITY, Art.Preparation, 
	func(helper): 
		return "Gain %s energy next turn.\nGain %s mana." % [helper.highlight(3), helper.mana(3)],
	func(game: Game):
		game.player_add_passive(Passives.GainEnergy)
		game.player_gain_mana(3)
)

@onready var lightning_strike := CardModel.new(
	"Lightning Strike", 4, Constants.CardType.ATTACK, Art.LightningStrike, 
	func(helper): 
		return "Deal %s damage for each card in hand.\nIf you have %s other cards in hand, %s the enemy." % \
			[helper.damage(3), helper.highlight(6), helper.highlight("stun")],
	func(game: Game):
		var hand_size := len(game.hand)
		game.hit_enemy(hand_size * 3)
		if hand_size == 6:
			game.enemy_add_passive(Passives.Stun)
)

@onready var magic_missiles := CardModel.new(
	"Magic Missiles", 1, Constants.CardType.ATTACK, Art.MagicMissiles, 
	func(helper): 
		return "Deal %s damage\n(%s for every %s played.)" % \
			[helper.damage((Constants.game.player_magic_missiles_cast if Constants.game != null else 0) * 2 + 2), 
			helper.damage(2, true), helper.highlight("Magic Missiles")],
	func(game: Game):
		game.player_magic_missiles_cast += 1
		game.emit_signal("player_passives_updated")
		var dmg := game.player_magic_missiles_cast * 2
		game.hit_enemy(dmg)
)

@onready var all: Array[CardModel] = [
	fire_strike,
	air_slash,
	meteor_strike,
	lightning_strike,
	magic_missiles,
	ice_wall,
	wall_of_force,
	arcane_shell,
	channel,
	zone_of_intellect,
	research,
	preparation,
]
