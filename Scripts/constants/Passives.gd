extends Node


@onready var IncreaseDamage := Passive.new("Increase Damage", Art.PassiveBlank, "Increase damage by 1")
@onready var HalveDamage := Passive.new("Halve Damage", Art.PassiveBlank, "Halve all damage")
@onready var GainEnergy := Passive.new("Prepared", Art.PassiveBlank, "Gain 2 additional energy next turn")
@onready var Stun := Passive.new("Stun", Art.PassiveBlank, "Skips next turn")
