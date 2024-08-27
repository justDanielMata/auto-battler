class_name BattleHandler extends Node2D

var turn_order: Array[BattleCharacter2D]
func _ready() -> void:
	Events.action_completed.connect(_on_character_action_completed)
	
func reset_actions() -> void:
	var current_character: BattleCharacter2D
	for child in get_children():
		for character in child.get_children():
			if not character is BattleCharacter2D:
				continue
			current_character = character as BattleCharacter2D
			current_character.current_action = null
			current_character.update_action()

func start_turn() -> void:
	turn_order = []
	for child in get_children():
		for character in child.get_children():
			if not character is BattleCharacter2D:
				continue
			turn_order.append(character)
	turn_order.sort_custom(
		func(a,b):
			if a.stats.agility <= b.stats.agility:
				return true
			else:
				return false
	)
	## now we have a turn order based on agility
	
	var first_character: BattleCharacter2D = turn_order[0] as BattleCharacter2D
	first_character.do_turn()
	
func _on_character_action_completed(character: BattleCharacter2D) -> void:
	var character_index = turn_order.find(character)
	if character_index == turn_order.size() - 1:
		Events.turn_ended.emit()
		reset_actions()
		start_turn()
		return
	var next_character: BattleCharacter2D = turn_order[character_index + 1] as BattleCharacter2D
	next_character.do_turn()
