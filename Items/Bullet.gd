extends Node3D
class_name Bullet

#CHANGE RANGE TO LIFETIME AND USE LIFETIME TO MAKE TIMER THAT DELETES BULLET WHEN IT STOPS
var velocity : float = 0.0
var damage : float = 0.0
var duration : float = 0.0
var saved_data : Dictionary = {}
var direction : Vector3
var bullet_instance : MeshInstance3D
var tick : float = 0.0

func _init(bullet_mesh : Mesh, init_velocity:float, init_duration:float, init_damage:float, init_direction : Vector3, init_data : Dictionary):
	velocity = init_velocity
	damage = init_damage
	duration = init_duration
	direction = init_direction
	saved_data = init_data
	top_level = true
	bullet_instance = MeshInstance3D.new()
	add_child(bullet_instance)
	bullet_instance.mesh = bullet_mesh

func _process(delta):
	if tick >= duration:
		queue_free()
	else:
		global_position = global_position + direction * velocity * delta
		var space_state = get_world_3d().direct_space_state
		var point_query = PhysicsPointQueryParameters3D.new()
		point_query.collision_mask = 0b101001
		point_query.collide_with_areas = true
		point_query.position = global_position
		var point_result = space_state.intersect_point(point_query)
		if point_result:
			on_hit(point_result)
		else:
			tick += delta

func on_hit(point_result):
	if point_result[0].collider is EnemyHitBox || point_result[0].collider is PlayerHitBox:
		point_result[0].collider.apply_damage(damage)
		if saved_data && saved_data.has("Trauma"):
			apply_trauma(point_result[0].collider)
	else:
		if saved_data && saved_data.has("Bubble"):
			apply_bubble(point_result[0])
			
	if point_result[0].collider:
		if saved_data && saved_data.has("Ricochet"):
			apply_ricochet(point_result[0])
		if saved_data && saved_data.has("Explosion"):
			apply_explosion(point_result[0])
	queue_free()

func apply_trauma(collider):
	var has_traumater = false
	for child in collider.get_children():
		if child is Traumater:
			has_traumater = true
		if !has_traumater:
			var trauma = str_to_var(saved_data["Trauma"])
			var trauma_tick = trauma.variables["trauma tick"] * saved_data["trauma tick"]
			var tick_damage = trauma.variables["trauma tick damage"] * saved_data["trauma tick damage"]
			var traumater = Traumater.new(trauma_tick, tick_damage)
			collider.add_child(traumater)

func apply_bubble(result):
	var bubble = str_to_var(saved_data["Bubble"])
	var bubble_tick = bubble.variables["bubble tick"] * saved_data["bubble tick"]
	var tick_damage = bubble.variables["bubble tick damage"] * saved_data["bubble tick damage"]
	var radius = bubble.variables["bubble radius"] * saved_data["bubble radius"]
	var bubble_duration = bubble.variables["bubble duration"] * saved_data["bubble duration"]
	var bubble_node = Bubble.new(radius, bubble_tick, tick_damage, bubble_duration, result.collider)
	bubble_node.global_position = global_position

func apply_explosion(result):
	var explos = str_to_var(saved_data["Explosion"])
	var radius = explos.variables["explosion radius"] * saved_data["explosion radius"]
	var explos_damage = explos.variables["explosion damage"] * saved_data["explosion damage"]
	var explos_node = Explosion.new(radius, explos_damage, result.collider)
	explos_node.global_position = global_position

func apply_ricochet(result):
	var new_direction = get_bounced_direction()
	var ricochet_node = Ricochet.new(bullet_instance.mesh, velocity, duration, damage, new_direction, saved_data, int(saved_data["ricochets"] - 1), result.collider)
	ricochet_node.global_position = global_position + new_direction * 0.001

func get_bounced_direction() -> Vector3:
	var space_state = get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.create(global_position - direction, global_position + direction, 0b101001)
	ray_query.collide_with_areas = true
	var ray_result = space_state.intersect_ray(ray_query)
	return direction.bounce(ray_result.normal)
