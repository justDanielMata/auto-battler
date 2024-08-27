class_name Stats extends Resource

signal stats_changed

@export_range(0.0, 10.0) var hit_chance_weight := 0.0
@export var max_health := 1
@export var max_mana := 3
@export var initial_mana := 0
@export var mana_gain := 1
@export var art: Texture
@export var agility := 1
@export var ai: PackedScene 

var accumulated_weight := 0.0
var health: int : set = set_health
var block: int : set = set_block
var mana: int : set = set_mana

func set_health(value: int) -> void:
	health = clampi(value, 0, max_health)
	stats_changed.emit()

func set_mana(value: int) -> void:
	mana = clampi(value, 0, max_mana)
	stats_changed.emit()

func set_block(value: int) -> void:
	block = clampi(value, 0, 999)
	stats_changed.emit()

func gain_mana() -> void:
	self.mana += mana_gain

func reset_mana() -> void:
	self.mana = initial_mana

func take_damage(damage: int) -> void:
	if damage <= 0:
		return
	var initial_damage = damage
	damage = clampi(damage - block, 0, damage)
	self.block = clampi(block - initial_damage, 0, block)
	self.health -= damage

func heal(amount: int) -> void:
	self.health += amount
	
func create_instance() -> Resource:
	var instance: Stats = self.duplicate()
	instance.health = max_health
	instance.max_mana = max_mana
	instance.hit_chance_weight = hit_chance_weight
	instance.mana = initial_mana
	instance.mana_gain = mana_gain
	instance.agility = agility
	instance.block = 0
	return instance
