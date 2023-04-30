extends Node
class_name Game
signal hand_updated
signal player_hp_updated
signal player_block_updated
signal player_energy_updated
signal player_mana_updated
signal player_passives_updated
signal enemy_hp_updated
signal enemy_block_updated
signal enemy_passives_updated
signal enemy_phase_updated
signal resolving_updated
signal result

const PLAYER_HP_MAX := 30
const PLAYER_MANA_MAX := 20

var hand: Array[CardModel] = []
var deck: Array[CardModel] = []
var discard: Array[CardModel] = []
var resolving := false
var ended := false
var enemy_model: EnemyModel = null
var enemy_max_hp := 100
var enemy_hp := 0
var enemy_damage_this_turn := 0
var enemy_block := 0
var enemy_passives: Array[Passive] = []
var enemy_phase := 0
var player_hp := 0
var player_block := 0
var player_energy := 0
var player_mana := 0
var player_passives: Array[Passive] = []
var player_magic_missiles_cast := 0


func _init():
	hand = []
	discard = []
	deck = Deck.deck.duplicate()
	resolving = false
	ended = false
	enemy_model = EnemyModels.all[Constants.root.level]
	enemy_max_hp = enemy_model.max_hp
	enemy_hp = enemy_max_hp
	enemy_damage_this_turn = 0
	enemy_block = 0
	enemy_passives = []
	enemy_phase = 0
	player_hp = PLAYER_HP_MAX
	player_block = 0
	player_energy = 3
	player_mana = 0
	player_passives = []
	
	deck.shuffle()
	draw(5)
	

func _attempt_draw() -> bool:
	if len(hand) >= 7:
		return false
		
	if len(deck) == 0:
		if len(discard) == 0:
			return false
		deck = discard
		discard = []
		deck.shuffle()
	
	var card = deck.pop_back()
	hand.push_back(card)
	return true
	

func draw(count: int):
	for i in range(count):
		_attempt_draw()
		
	emit_signal("hand_updated")
	

func player_turn():
	draw(2)
	
	player_energy = 3
	var bonus_energy = player_count_passive(Passives.GainEnergy)
	player_energy += 3 * bonus_energy
	emit_signal("player_energy_updated")
	
	player_block = 0
	emit_signal("player_block_updated")
	
	player_remove_passives(Passives.GainEnergy)
	player_remove_passives(Passives.HalveDamage)
	
	resolving = false
	emit_signal("resolving_updated")
	

func enemy_turn():
	resolving = true
	emit_signal("resolving_updated")
	
	enemy_damage_this_turn = 0
	enemy_block = 0
	emit_signal("enemy_block_updated")
	
	var skipped := enemy_count_passive(Passives.Stun)
	enemy_remove_passives(Passives.HalveDamage)
	enemy_remove_passives(Passives.Stun)
	if skipped > 0:
		Audio.play_stun()
		if enemy_model.title == "The King" && enemy_phase == 0 && enemy_hp == enemy_max_hp / 2:
			enemy_phase = 1
		player_turn()
		return
		
	enemy_model.play(enemy_phase, self)
	enemy_phase = (enemy_phase + 1) % len(enemy_model.run)
	emit_signal("enemy_phase_updated")
	
	player_turn()
	

func play(idx: int) -> bool:
	if resolving or ended:
		return false
		
	var card := hand[idx]
	if player_energy < card.cost:
		return false
	
	hand.remove_at(idx)
	discard.push_back(card)
	emit_signal("hand_updated")
	
	player_energy -= card.cost
	emit_signal("player_energy_updated")
	resolving = true
	emit_signal("resolving_updated")
	card.play(self)
	resolving = false
	emit_signal("resolving_updated")
	
	
	return true
	

func player_add_passive(passive: Passive):
	player_passives.push_back(passive)
	emit_signal("player_passives_updated")
	

func enemy_remove_passives(passive: Passive):
	enemy_passives = enemy_passives.filter(func(v): return v.title != passive.title)
	emit_signal("enemy_passives_updated")
	

func enemy_add_passive(passive: Passive):
	enemy_passives.push_back(passive)
	emit_signal("enemy_passives_updated")
	

func player_remove_passives(passive: Passive):
	player_passives = player_passives.filter(func(v): return v.title != passive.title)
	emit_signal("player_passives_updated")
	

func player_count_passive(passive: Passive) -> int:
	var count := 0
	for p in player_passives:
		if passive.title == p.title:
			count += 1
		
	return count
	

func enemy_count_passive(passive: Passive) -> int:
	var count := 0
	for p in enemy_passives:
		if passive.title == p.title:
			count += 1
		
	return count
	

func calculate_player_damage(damage: int) -> int:
	var increase := player_count_passive(Passives.IncreaseDamage)
	damage += increase
	for i in range(enemy_count_passive(Passives.HalveDamage)):
		damage /= 2
	return damage
	

func calculate_enemy_damage(damage: int) -> int:
	var increase := enemy_count_passive(Passives.IncreaseDamage)
	damage += increase
	for i in range(player_count_passive(Passives.HalveDamage)):
		damage /= 2
	return damage
	

func hit_enemy(damage: int, raw: bool = false) -> int:
	if not raw:
		damage = calculate_player_damage(damage)
		
	if enemy_block >= damage:
		enemy_block -= damage
		damage = 0
		Audio.play_block()
		emit_signal("enemy_block_updated")
	elif enemy_block > 0:
		damage -= enemy_block
		enemy_block = 0
		enemy_hp -= damage
		enemy_damage_this_turn += damage
		Audio.play_hit_enemy()
		emit_signal("enemy_hp_updated")
		emit_signal("enemy_block_updated")
	else:
		enemy_hp -= damage
		enemy_damage_this_turn += damage
		Audio.play_hit_enemy()
		emit_signal("enemy_hp_updated")
	
	if Constants.root.level == Constants.Level.LEVEL_TWO && enemy_phase == 0:
		if enemy_hp < enemy_max_hp / 2:
			enemy_hp = enemy_max_hp / 2
			emit_signal("enemy_hp_updated")
	if enemy_hp <= 0:
		ended = true
		emit_signal("result", true)
		
	return damage

func hit_player(damage: int, raw: bool = false) -> int:
	if not raw:
		damage = calculate_enemy_damage(damage)
		
	if player_block >= damage:
		player_block -= damage
		Audio.play_block()
		emit_signal("player_block_updated")
		return 0
	elif player_block > 0:
		damage -= player_block
		player_block = 0
		player_hp -= damage
		Audio.play_hit_player()
		emit_signal("player_hp_updated")
		emit_signal("player_block_updated")
	else:
		player_hp -= damage
		Audio.play_hit_player()
		emit_signal("player_hp_updated")
		
	if player_hp <= 0:
		ended = true
		emit_signal("result", false)
		
	return damage

func enemy_gain_hp(amount: int):
	enemy_hp = min(enemy_hp + amount, enemy_max_hp)
	emit_signal("enemy_hp_updated")
	

func enemy_gain_block(block: int):
	enemy_block += block
	emit_signal("enemy_block_updated")
	

func player_gain_block(block: int):
	player_block += block
	emit_signal("player_block_updated")
	

func player_gain_mana(mana: int):
	if player_mana >= PLAYER_MANA_MAX:
		return
		
	player_mana = min(player_mana + mana, PLAYER_MANA_MAX)
	emit_signal("player_mana_updated")
	

func player_spend_mana(mana: int) -> bool:
	if player_mana < mana:
		return false
		
	player_mana -= mana
	emit_signal("player_mana_updated")
	return true
	
