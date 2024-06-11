extends State
@export var weapon : EnemyGun
var tick : float = 0.0

func enter():
	pass

func exit():
	pass

func process_physics(delta):
	if tick + delta <= 1/weapon.stats.variables["fire rate"]:
		var player_position = state_machine.player.global_position
		var bullet_range = weapon.stats.variables["duration"] * weapon.stats.variables["velocity"]
		var move_position = player_position - body.global_position.direction_to(player_position) * 3
		var move_direction = body.global_position.direction_to(Vector3(move_position.x, body.global_position.y, move_position.z))
		body.velocity = move_direction * body.stats["speed"]
		
		body.look_at(Vector3(player_position.x, body.global_position.y, player_position.z))
		tick += delta
	else:
		tick = 0.0
		transition.emit("Jump_State")
	

