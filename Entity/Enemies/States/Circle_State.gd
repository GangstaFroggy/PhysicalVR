extends State
var time_passed : float = 0.0
@export var weapon : EnemyWeapon

func process_physics(delta):
	time_passed += delta
	if time_passed >= weapon.stats.variables["cooldown"]:
		transition.emit("Charge_State")
		time_passed = 0.0
	else:
		var player = state_machine.player
		var player_position = player.global_position
		body.velocity = body.global_transform.basis.x
		body.look_at(Vector3(player_position.x, body.global_position.y, player_position.z))

