extends State
@export var weapon : EnemyGun

func process_physics(_delta):
	var player_position = state_machine.player.global_position
	var bullet_range = weapon.stats.variables["duration"] * weapon.stats.variables["velocity"]
	var move_position = player_position - body.global_position.direction_to(player_position) * 4.5
	var move_direction = body.global_position.direction_to(Vector3(move_position.x, body.global_position.y, move_position.z))
	body.velocity = move_direction * body.stats["speed"]
	
	body.look_at(Vector3(player_position.x, body.global_position.y, player_position.z))
	var player_velocity = state_machine.player.velocity
	var neck_position = state_machine.player.neck.global_position
	var muzzle_velocity = weapon.stats.variables["velocity"]
	var muzzle_position = weapon.muzzle.global_position
	weapon.attack(predict_position(neck_position, player_velocity, muzzle_velocity, muzzle_position))

func predict_position(player_position, player_velocity, muzzle_speed, muzzle_position):
	var time = player_position.distance_to(muzzle_position) / muzzle_speed
	var predicted_position = player_position + player_velocity * time
	return predicted_position
