extends State
@export var weapon : EnemyGun
@export var aim_time : float
var has_fired : bool = false
var tick : float = 0.0
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity") 

func enter():
	body.velocity = Vector3.ZERO

func exit():
	pass

func process_physics(delta):
	if tick + delta >= aim_time:
		var player = state_machine.player
		weapon.attack(player.neck.global_position)
		has_fired = true
		tick = 0.0
	elif has_fired == false:
		var player_pos = state_machine.player.global_position
		body.look_at(Vector3(player_pos.x, body.global_position.y, player_pos.z))
		tick += delta
	else:
		body.velocity.y -= gravity * delta
		body.move_and_slide()
		if body.is_on_floor():
			has_fired = false
			transition.emit("Track_State")

