extends Bullet
class_name Ricochet
var ricochets : int
var parent : Node3D

func _init(bullet_mesh : Mesh, init_velocity:float, init_duration:float, init_damage:float, init_direction : Vector3, init_data : Dictionary, init_ricochets : int, init_parent : Node3D):
	super(bullet_mesh, init_velocity, init_duration, init_damage, init_direction, init_data)
	self.ricochets = init_ricochets
	self.parent = init_parent
	parent.add_child(self)

func _process(delta):
	super._process(delta)

func apply_ricochet(_result):
	if ricochets > 0:
		var new_direction = get_bounced_direction()
		var ricochet_node = Ricochet.new(bullet_instance.mesh, velocity, duration, damage, new_direction, saved_data, ricochets - 1, parent)
		ricochet_node.global_position = global_position + new_direction * 0.001
