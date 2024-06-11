extends State
@export var weapon : EnemyWeapon

func process_physics(delta):
	if weapon.area.has_overlapping_areas():
		for hitbox in weapon.area.get_overlapping_areas():
			if hitbox is PlayerHitBox:
				transition.emit("Retreat_State")
	var player_position = state_machine.player.global_position
	var move_direction = body.global_position.direction_to(Vector3(player_position.x, body.global_position.y, player_position.z))
	body.velocity = move_direction * body.stats["speed"]
	body.look_at(Vector3(player_position.x, body.global_position.y, player_position.z))
	body.move_and_slide()

func exit():
	for hitbox in weapon.area.get_overlapping_areas():
		if hitbox is PlayerHitBox:
			hitbox.apply_damage(weapon.stats.variables["damage"])
