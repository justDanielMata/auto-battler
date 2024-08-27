extends Action

@export var damage := 4
@export var block := 4

func is_performable() -> bool:
	if not character:
		return false

	var has_enough_mana := character.stats.mana >= character.stats.max_mana
	return has_enough_mana

func perform_action() -> void:
	if not character or not target:
		return
	
	var tween := create_tween().set_trans(Tween.TRANS_QUINT)
	var start := character.global_position
	var end := target.global_position + Vector2.RIGHT * 16
	var damage_effect = DamageEffect.new()
	var target_array:Array[BattleCharacter2D] = [target]
	damage_effect.amount = damage
	var block_effect := BlockEffect.new()
	block_effect.amount = block
	
	tween.tween_property(character, "global_position", end, 0.4)
	tween.tween_callback(damage_effect.execute.bind(target_array))
	tween.tween_interval(0.25)
	tween.tween_property(character, "global_position", start, 0.4)
	character.stats.reset_mana()
	tween.finished.connect(
		func():
			block_effect.execute([character])
			Events.action_completed.emit(character)
	)
