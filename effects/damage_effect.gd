class_name DamageEffect extends Effect

var amount := 0

func execute(targets: Array[BattleCharacter2D]) -> void:
	for target in targets:
		if not target:
			continue
		if target is Enemy or target is BattleCharacter2D:
			target.take_damage(amount)
