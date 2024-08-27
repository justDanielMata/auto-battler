extends Action

@export var damage := 2

func perform_action() -> void:
	if not character or not target:
		return
	
	var tween := create_tween().set_trans(Tween.TRANS_QUINT)
	var start := character.global_position
	var end := target.global_position + Vector2.LEFT * 16
	var damage_effect = DamageEffect.new()
	var target_array: Array[BattleCharacter2D] = [target]
	damage_effect.amount = damage
	
	
	tween.tween_property(character, "global_position", end, 0.4)
	tween.tween_callback(damage_effect.execute.bind(target_array))
	tween.tween_callback(character.stats.gain_mana)
	tween.tween_interval(0.25)
	tween.tween_property(character, "global_position", start, 0.4)
	
	tween.finished.connect(
		func():
			Events.action_completed.emit(character)
	)
