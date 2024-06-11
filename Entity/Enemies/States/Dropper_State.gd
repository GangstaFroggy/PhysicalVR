extends State
@export var launcher : EnemyWeapon

func process_physics(delta):
	var rand_vector : Vector3 = Vector3(randf_range(0, 3), randf_range(0, 3), randf_range(0, 3))
	var direction = body.global_position.direction_to(state_machine.player.global_position + Vector3.UP * 3 + rand_vector)
	body.velocity = direction * body.stats["speed"]
	body.look_at(Vector3(state_machine.player.global_position.x, body.global_position.y, state_machine.player.global_position.z))
	body.move_and_slide()
	launcher.attack(body.global_position - Vector3(0, 100, 0))

