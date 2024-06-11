extends Area3D
class_name Bubble
var tick : float = 0.0
var tick_damage : float = 0.0
var duration : float = 0.0
var current_tick : float = 0.0
var current_time : float = 0.0

func _init(radius : float, init_tick : float, init_tick_damage : float, init_duration : float, parent : Node3D):
	tick = 1/init_tick
	tick_damage = init_tick_damage
	duration = init_duration
	self.collision_mask = 0b1000
	self.collision_layer = 0b0
	var mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = SphereMesh.new()
	mesh_instance.mesh.height = radius * 2
	mesh_instance.mesh.radius = radius
	mesh_instance.mesh.material = StandardMaterial3D.new()
	mesh_instance.mesh.material.albedo_color = Color.PURPLE
	mesh_instance.mesh.material.shading_mode = 3
	var collision_shape = CollisionShape3D.new()
	collision_shape.shape = SphereShape3D.new()
	collision_shape.shape.radius = radius
	add_child(mesh_instance)
	add_child(collision_shape)
	parent.add_child(self)

func _process(delta):
	if current_tick + delta >= tick:
		if has_overlapping_areas():
			for area in get_overlapping_areas():
				area.apply_damage(tick_damage)
		current_tick = 0.0
	else:
		current_tick += delta
	if current_time + delta >= duration:
		queue_free()
	else:
		current_time += delta
