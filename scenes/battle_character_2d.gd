class_name BattleCharacter2D extends CharacterBody2D

@export  var stats : Stats : set = set_character_stats
@onready var stats_ui = $StatsUI
@onready var mana_ui = $ManaUI
@export var projectile: Texture
@export var ultimate_projectile: Texture

var action_picker: ActionPicker
var current_action: Action : set = set_current_action

func set_current_action(value: Action) -> void:
	current_action = value

func set_character_stats(value: Stats) -> void:
	stats = value.create_instance()
	
	if not stats.stats_changed.is_connected(update_stats):
		stats.stats_changed.connect(update_stats)
		stats.stats_changed.connect(update_action)
		
	update_character()

func setup_ai() -> void:
	if action_picker:
		action_picker.queue_free()
	var new_action_picker: ActionPicker = stats.ai.instantiate()
	add_child(new_action_picker)
	action_picker = new_action_picker
	action_picker.character = self
		
func update_stats() -> void:
	stats_ui.update_stats(stats)

func update_action() -> void:
	if not action_picker:
		return
	if not current_action:
		current_action = action_picker.get_action()
		return
	
	var new_conditional_action := action_picker.get_first_conditional_action()
	if new_conditional_action and current_action != new_conditional_action:
		current_action = new_conditional_action
	
func update_character() -> void:
	if not stats is Stats:
		return
		
	if not is_inside_tree():
		await ready
	
	mana_ui.char_stats = stats
	setup_ai()
	update_stats()
	
func do_turn() -> void:
	if not current_action:
		return
	current_action.perform_action()

func take_damage(damage: int) -> void:
	if stats.health <= 0:
		return
	
	stats.take_damage(damage)
	stats.gain_mana()
	
	if stats.health <= 0:
		queue_free()
		Events.character_died.emit(self)

