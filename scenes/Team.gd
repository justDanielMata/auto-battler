class_name Team extends Node

@onready var total_weight := 0.0

func _ready() -> void:
	setup_chances()

func setup_chances() -> void:
	var character: BattleCharacter2D
	
	for child in get_children():
		character = child as BattleCharacter2D
		total_weight += character.stats.hit_chance_weight
		character.stats.accumulated_weight = total_weight

func get_target() -> BattleCharacter2D:
	var target: BattleCharacter2D
	var roll := randf_range(0.0, total_weight)
	
	for child in get_children():
		target = child as BattleCharacter2D
		if target.stats.accumulated_weight > roll:
			return target

	return null

func _on_child_order_changed():
	setup_chances()
