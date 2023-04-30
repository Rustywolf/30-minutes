extends Node


@onready var Jackalope := \
	EnemyModel.new("Jackalope", 20, Art.EnemyAntler) \
		.add_action(
			func(helper):
				return "Slashing for %s damage" % helper.damage(5),
			func(game: Game):
				game.hit_player(5),
		) \
		.add_action(
			func(helper):
				return "Ramming for %s damage" % helper.damage(20),
			func(game: Game):
				game.hit_player(20),
		) \
		.add_action(
			func(helper):
				return "Resting...",
			func(game: Game):
				pass,
		)


@onready var Phoenix := \
	EnemyModel.new("Phoenix", 50, Art.EnemyFeather) \
		.add_action(
			func(helper):
				return "Roosts to increase future damage",
			func(game: Game):
				game.enemy_add_passive(Passives.IncreaseDamage),
		) \
		.add_action(
			func(helper):
				return "Swoops three times, dealing %s damage each" % helper.damage(1),
			func(game: Game):
				game.hit_player(1)
				game.hit_player(1)
				game.hit_player(1),
		) \
		.add_action(
			func(helper):
				return "Burns for %s damage, healing damage dealt. Stunned upon taking %s damage." % [helper.damage(12), helper.highlight(20)],
			func(game: Game):
				if game.enemy_damage_this_turn < 20:
					var dmg := game.hit_player(12)
					if dmg > 0:
						game.enemy_gain_hp(dmg)
				else:
					Audio.play_stun(),
		)


@onready var King := \
	EnemyModel.new("The King", 100, Art.EnemyCrown) \
		.add_action(
			func(helper):
				return "Strikes for %s damage, and gains %s block" % [helper.damage(8), helper.block(5)],
			func(game: Game):
				game.hit_player(8)
				game.enemy_gain_block(5)
				if game.enemy_hp > game.enemy_max_hp / 2:
					game.enemy_phase -= 1,
		) \
		.add_action(
			func(helper):
				return "Blindly swings in a rage, dealing %s damage and increasing his damage by %s" % [helper.damage(5), helper.highlight(5)],
			func(game: Game):
				game.hit_player(5)
				game.enemy_add_passive(Passives.IncreaseDamage)
				game.enemy_add_passive(Passives.IncreaseDamage)
				game.enemy_add_passive(Passives.IncreaseDamage)
				game.enemy_add_passive(Passives.IncreaseDamage)
				game.enemy_add_passive(Passives.IncreaseDamage)
				game.enemy_phase -= 1,
		)

@onready var all: Array[EnemyModel] = [
	Jackalope,
	Phoenix,
	King
]
