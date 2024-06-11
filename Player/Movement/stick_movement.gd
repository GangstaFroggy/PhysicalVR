extends Node
class_name StickMovementModule

var can_move : bool = true
@onready var controller : XRController3D = get_parent()
@onready var neck : Node3D = get_parent().get_parent().get_child(0).get_child(0)
@onready var body : CharacterBody3D = get_parent().get_parent().get_parent()
@export var player : Player

func _physics_process(_delta):
	if can_move:
		var direction : Vector3 = Vector3.ZERO
		if controller.get_vector2("joystick") != Vector2.ZERO:
			var movement_input : Vector2 = controller.get_vector2("joystick") 
			direction = neck.global_transform.basis * Vector3(movement_input.x, 0, -movement_input.y)
			direction.y = 0
			direction = direction.normalized()
		if direction:
			body.velocity.x = direction.x * player.stats["speed"]
			body.velocity.z = direction.z * player.stats["speed"]
		else:
			body.velocity.x = 0
			body.velocity.z = 0

		body.move_and_slide()

