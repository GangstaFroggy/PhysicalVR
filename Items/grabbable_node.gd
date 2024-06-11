extends Node3D
class_name GrabbableNode

var gripPoint1:Node3D
var gripPoint2:Node3D
var controller1:Node3D = null
var controller2:Node3D = null
@export var holster : Node3D
var holster_offset : Transform3D

func _ready():
	holster_offset = holster.global_transform.affine_inverse() * global_transform

func _process(_delta):
	move_to_grab()

func move_to_grab():
	if controller1 && controller2 == null:
		var grab_transform = gripPoint1.global_transform.affine_inverse() * global_transform
		global_transform = controller1.global_transform * grab_transform
	elif controller1 && controller2:
		var offset2 = gripPoint2.global_transform.affine_inverse() * global_transform
		var offset1 = gripPoint1.global_transform.affine_inverse() * global_transform
		var transform2 = controller2.global_transform * offset2
		var transform1 = controller1.global_transform * offset1
		global_transform = transform2.interpolate_with(transform1, 0.5)
	else:
		global_transform = holster.global_transform * holster_offset
		
