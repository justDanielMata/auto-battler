extends Action

@export var max_uses:= 3
var used_count := 0
@export var damage := 1

func is_performable() -> bool:
	if not character:
		return false

	var has_enough_mana := character.stats.mana >= character.stats.max_mana
	return has_enough_mana

func perform_action() -> void:
	used_count += 1
	var projectile_sprite = Sprite2D.new()
	if not character or not target:
		return
	projectile_sprite.texture = character.ultimate_projectile
	target.add_child(projectile_sprite)
	projectile_sprite.global_position = target.global_position
	var tween := create_tween().set_trans(Tween.TRANS_QUINT)
	var damage_effect = DamageEffect.new()
	var target_array: Array[BattleCharacter2D] = [target]
	damage_effect.amount = damage + used_count
	
	tween.tween_property(projectile_sprite, "scale", Vector2(1.2,1.8), 0.8)
	tween.tween_callback(damage_effect.execute.bind(target_array))
	tween.tween_interval(0.25)
	tween.tween_callback(projectile_sprite.queue_free)
	tween.tween_callback(character.stats.reset_mana)
	tween.finished.connect(
		func():
			Events.action_completed.emit(character)
	)
