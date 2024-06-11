extends PlayerHitBox
@export var collision : CollisionShape3D

func _process(_delta):
	global_position = Vector3(collision.global_position.x, collision.global_position.y - collision.shape.height/2, collision.global_position.z)
