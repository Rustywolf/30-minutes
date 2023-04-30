extends Control


var victory := false

func _ready():
	$Enemy/HP.max_value = Constants.game.enemy_max_hp
	$Player/HP.max_value = Constants.game.PLAYER_HP_MAX
	$Player/Mana.max_value = Constants.game.PLAYER_MANA_MAX
	
	_update_enemy_model()
	_update_enemy_block()
	_update_enemy_hp()
	_update_enemy_phase()
	_update_player_block()
	_update_player_energy()
	_update_player_hp()
	_update_player_mana()
	_update_hand()
	
	Constants.game.connect("hand_updated", _update_hand)
	Constants.game.connect("player_hp_updated", _update_player_hp)
	Constants.game.connect("player_block_updated", _update_player_block)
	Constants.game.connect("player_energy_updated", _update_player_energy)
	Constants.game.connect("player_mana_updated", _update_player_mana)
	Constants.game.connect("player_passives_updated", _update_enemy_phase)
	Constants.game.connect("enemy_hp_updated", _update_enemy_hp)
	Constants.game.connect("enemy_block_updated", _update_enemy_block)
	Constants.game.connect("enemy_passives_updated", _update_enemy_phase)
	Constants.game.connect("enemy_phase_updated", _update_enemy_phase)
	Constants.game.connect("enemy_hp_updated", _update_enemy_phase)
	Constants.game.connect("resolving_updated", _update_resolving)
	Constants.game.connect("result", _on_result)
	

func _update_enemy_model():
	$Enemy/Avatar.texture = Constants.game.enemy_model.art
	$Enemy/Title.text = "[center]%s" % Constants.game.enemy_model.title
	

func _update_enemy_hp():
	$Enemy/HP.value = Constants.game.enemy_hp
	$Enemy/HPText.text = "[center]%s/%s" % [Constants.game.enemy_hp, Constants.game.enemy_max_hp]
	

func _update_enemy_block():
	$Enemy/Block.visible = Constants.game.enemy_block > 0
	$Enemy/Block/BlockText.text = "[center]%s" % Constants.game.enemy_block
	

func _update_enemy_phase():
	if Constants.game.enemy_count_passive(Passives.Stun) > 0 or \
		(Constants.root.level == Constants.Level.LEVEL_ONE && Constants.game.enemy_phase == 2 && Constants.game.enemy_damage_this_turn >= 20):
		$Enemy/Plan/Text.text = "[center][color=#eeb4eb]Stunned[/color], skipping turn."
	else:
		$Enemy/Plan/Text.text = "[center]%s" % Constants.game.enemy_model.get_desc(Constants.game.enemy_phase)
	

func _update_player_hp():
	$Player/HP.value = Constants.game.player_hp
	$Player/HPText.text = "[center]%s/%s" % [Constants.game.player_hp, Constants.game.PLAYER_HP_MAX]
	

func _update_player_block():
	$Player/Block.visible = Constants.game.player_block > 0
	$Player/Block/BlockText.text = "[center]%s" % Constants.game.player_block
	

func _update_player_energy():
	$Player/Energy/EnergyAmount.text = "%s" % Constants.game.player_energy
	

func _update_player_mana():
	$Player/Mana.value = Constants.game.player_mana
	$Player/ManaText.text = "[center]%s/%s" % [Constants.game.player_mana, Constants.game.PLAYER_MANA_MAX]
	

func _update_hand():
	$CardInfo/Deck/Count.text = "%s" % len(Constants.game.deck)
	$CardInfo/Discard/Count.text = "%s" % len(Constants.game.discard)
	

func _update_resolving():
	$EndTurn.enabled = !Constants.game.resolving
	

func _on_end_turn_pressed():
	Constants.game.enemy_turn()
	

func _on_result(_victory):
	victory = _victory
	$EndGame.visible = true
	$EndGame/DefeatText.visible = !victory
	$EndGame/VictoryText.visible = victory
	$AnimationPlayer.play("EndGame")
	if victory:
		Audio.play_victory()
	else:
		Audio.play_defeat()
	
func _on_end_animation():
	Constants.root.hide_inspect_message()
	Constants.root.hide_action_message()
	Constants.root.transition_from_combat(victory)
	
