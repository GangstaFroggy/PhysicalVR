extends Node
class_name StickRotationModule

@onready var controller : XRController3D = get_parent()
@onready var origin : XROrigin3D = get_parent().get_parent()
@onready var neck : Node3D = get_parent().get_parent().get_child(0).get_child(0)

func _physics_process(_delta):
	if controller.get_vector2("joystick") != Vector2.ZERO:
		var rotation_direction = controller.get_vector2("joystick")
		var player_pos = neck.global_position
		origin.global_position = player_pos
		origin.global_rotation_degrees.y -= rotation_direction.x * 5
		player_pos = neck.global_position
		origin.global_position += origin.global_position - neck.global_position
