class_name Enemy extends BattleCharacter2D

@onready var sprite_2d = $Sprite2D

func update_enemy() -> void:
	if not is_inside_tree():
		await ready
	
	sprite_2d.texture = stats.art
