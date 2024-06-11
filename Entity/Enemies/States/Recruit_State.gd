extends State
@export var weapon: Node3D

func process_physics(_delta):
	var player_position = state_machine.player.global_position
	var move_position = player_position - body.global_position.direction_to(player_position) * 4
	var move_direction = body.global_position.direction_to(Vector3(move_position.x, body.global_position.y, move_position.z))
	body.velocity = move_direction * body.stats["speed"]
	
	body.look_at(Vector3(player_position.x, body.global_position.y, player_position.z))
	weapon.attack(state_machine.player.neck.global_position)
