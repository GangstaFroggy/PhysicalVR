extends Node3D
class_name EnemySpawner
var wave : Wave
var ticklist : Array[float]

func _init(init_wave : Wave):
	self.wave = init_wave
	self.ticklist = []
	for enmy in wave.enemies:
		self.ticklist.append(0.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for idx in wave.enemies.size():
		if ticklist[idx] + delta > wave.enemies[idx].spawn_rate:
			ticklist[idx] = 0.0
			spawn_enemy(idx)
		else:
			ticklist[idx] += delta

func spawn_enemy(index : int):
	var enemy = wave.enemies[index]
	var offset_x = randf_range(enemy.player_offset_min, enemy.player_offset_max)
	var offset_z = randf_range(enemy.player_offset_min, enemy.player_offset_max)
	var offset = Vector3(offset_x, 0.0, offset_z)
	var space_state = get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.create(global_position + offset, global_position + offset - Vector3.UP * 100, 0b1)
	var ray_result = space_state.intersect_ray(ray_query)
	if ray_result:
		var new_enemy = enemy.enemy_scene.instantiate()
		add_child(new_enemy)
		new_enemy.global_position = ray_result.position + Vector3(0, 0.2, 0)
