extends Node2D

@onready var battle_handler = $BattleHandler

func _ready() -> void:
	start_battle()
	
func start_battle() -> void:
	battle_handler.reset_actions()
	battle_handler.start_turn()
