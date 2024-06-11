extends State
var distance : float = 0.0
var time : float = 0.0
var current_time : float = 0.0

func enter():
	distance = randf_range(3, 5)
	time = distance/body.stats["speed"]

func process_physics(delta):
	current_time += delta
	if current_time >= time:
		transition.emit("Circle_State")
	else:
		var player_position = state_machine.player.global_position
		var move_direction = -body.global_position.direction_to(Vector3(player_position.x, body.global_position.y, player_position.z))
		body.velocity = move_direction * body.stats["speed"]
		body.look_at(Vector3(player_position.x, body.global_position.y, player_position.z))
		body.move_and_slide()

