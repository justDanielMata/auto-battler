class_name ActionPicker extends Node

@export var opposite_team_group_name: String
@export var character: BattleCharacter2D : set = _set_character
@export var target: BattleCharacter2D : set = _set_target

func _ready() -> void:
	var team_handler: Team = get_tree().get_first_node_in_group(opposite_team_group_name) as Team
	target = team_handler.get_target()

func get_action() -> Action:
	var action:= get_first_conditional_action()
	if action:
		return action
	return get_base_action()
	
func get_first_conditional_action() -> Action:
	var action: Action
	for child in get_children(): 
		action = child as Action
		if not action or action.type != Action.Type.CONDITIONAL:
			continue
		
		if action.is_performable():
			return action
		
	return null

func get_base_action() -> Action:
	var action: Action
	for child in get_children():
		action = child as Action
		if not action or action.type != Action.Type.BASIC:
			continue
		return action
	return null

func _set_character(value: BattleCharacter2D) -> void:
	character = value
	for action in get_children():
		action.character = character
	
func _set_target(value: BattleCharacter2D) -> void:
	target = value
	for action in get_children():
		action.target = target

