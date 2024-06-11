extends Area3D
class_name EnemyHitBox

@export var entity : Entity
@export var flesh_material : Material
@export var armor_material : Material 
@export var mesh : MeshInstance3D

func _physics_process(_delta):
	mesh.set_surface_override_material(0, null)
	
func apply_damage(damage : float):
	if entity.armor >= damage:
		entity.armor -= damage
		mesh.set_surface_override_material(0, armor_material)
	else:
		entity.health -= 1
		mesh.set_surface_override_material(0, flesh_material)
