extends Action

@export var damage := 1

func perform_action() -> void:
	var projectile_sprite = Sprite2D.new()
	if not character or not target:
		return
	projectile_sprite.texture = character.projectile
	character.add_child(projectile_sprite)
	var tween := create_tween().set_trans(Tween.TRANS_QUINT)
	var end := target.global_position
	var damage_effect = DamageEffect.new()
	var target_array: Array[BattleCharacter2D] = [target]
	damage_effect.amount = damage
	
	
	tween.tween_property(projectile_sprite, "global_position", end, 0.8)
	tween.tween_callback(damage_effect.execute.bind(target_array))
	tween.tween_callback(character.stats.gain_mana)
	tween.tween_callback(target.stats.gain_mana)
	tween.tween_interval(0.25)
	tween.tween_callback(projectile_sprite.queue_free)
	
	tween.finished.connect(
		func():
			Events.action_completed.emit(character)
	)
