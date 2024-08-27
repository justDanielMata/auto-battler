class_name Action extends Node

enum Type { CONDITIONAL, BASIC}

@export var type: Type

var character: BattleCharacter2D
var target: Node2D

func is_performable() -> bool:
	return false

func perform_action() -> void:
	pass
	
