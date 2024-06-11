extends Node3D
class_name Explosion
var radius : float = 0.0
var damage : float = 0.0
var is_done : bool = false

func _init(init_radius : float, init_damage : float, parent : Node3D):
	self.radius = init_radius
	self.damage = init_damage
	parent.add_child(self)

func _ready():
	var mesh_inst : MeshInstance3D = MeshInstance3D.new()
	var mesh : SphereMesh = SphereMesh.new()
	var material : StandardMaterial3D = StandardMaterial3D.new()
	material.albedo_color = Color.WHITE
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mesh.radius = radius
	mesh.height = radius * 2
	mesh.material = material
	mesh_inst.mesh = mesh
	self.add_child(mesh_inst)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if is_done == true:
		queue_free()
	else:
		var space_state = get_world_3d().direct_space_state
		var sphere_query : PhysicsShapeQueryParameters3D = PhysicsShapeQueryParameters3D.new()
		sphere_query.shape = SphereShape3D.new()
		sphere_query.shape.radius = radius
		sphere_query.collide_with_areas = true
		sphere_query.collide_with_bodies = false
		sphere_query.collision_mask = 0b1000
		var result = space_state.intersect_shape(sphere_query)
		if result:
			result[0].collider.apply_damage(damage)
		is_done = true
		
