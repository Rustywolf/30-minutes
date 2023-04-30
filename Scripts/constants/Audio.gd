extends Node

@onready var _sound_block : AudioStream = preload("res://Assets/Audio/Block.wav")
@onready var _sound_button : AudioStream = preload("res://Assets/Audio/Button.wav")
@onready var _sound_hit_enemy : AudioStream = preload("res://Assets/Audio/HitEnemy.wav")
@onready var _sound_hit_player : AudioStream = preload("res://Assets/Audio/HitPlayer.wav")
@onready var _sound_play : AudioStream = preload("res://Assets/Audio/Play2.wav")
@onready var _sound_stun : AudioStream = preload("res://Assets/Audio/Stun.wav")
@onready var _sound_textbox : AudioStream = preload("res://Assets/Audio/TextBox.wav") 
@onready var _sound_defeat : AudioStream = preload("res://Assets/Audio/Defeat.wav") 
@onready var _sound_victory : AudioStream = preload("res://Assets/Audio/Victory.wav") 

func _play(sound: AudioStream):
	var player := AudioStreamPlayer.new()
	Constants.root.add_child(player)
	player.volume_db = -20
	player.stream = sound
	player.play()
	

func play_block():
	_play(_sound_block)
	

func play_button():
	_play(_sound_button)
	

func play_hit_enemy():
	_play(_sound_hit_enemy)
	

func play_hit_player():
	_play(_sound_hit_player)
	

func play_play():
	_play(_sound_play)
	

func play_stun():
	_play(_sound_stun)
	

func play_textbox():
	_play(_sound_textbox)
	

func play_defeat():
	_play(_sound_defeat)
	

func play_victory():
	_play(_sound_victory)
	
