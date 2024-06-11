extends Node3D
@export var camera : Node3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	look_at(global_position + Vector3(-camera.global_transform.basis.z.x, 0, -camera.global_transform.basis.z.z).normalized())
