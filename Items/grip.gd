extends Area3D
class_name Grip

@export var freeGrip : bool
@export var snapPoint : Node3D
@onready var parent = get_parent()


func grab(initController:Node3D) -> void:
	if !freeGrip:
		if parent.controller1:
			parent.controller2 = parent.controller1
			parent.controller1 = initController
			parent.gripPoint2 = parent.gripPoint1
			parent.gripPoint1 = make_grip(initController.global_transform)
		else:
			parent.controller1 = initController
			parent.gripPoint1 = snapPoint
	else:
		if parent.controller1:
			parent.controller2 = parent.controller1
			parent.controller1 = initController
			parent.gripPoint2 = parent.gripPoint1
			parent.gripPoint1 = make_grip(initController.global_transform)
		else:
			parent.controller1 = initController
			parent.gripPoint1 = make_grip(initController.global_transform)
		
func release(initController:Node3D) -> void:
	if parent.controller1 && parent.controller2 == null:
		parent.controller1 = null
		if !parent.gripPoint1.is_in_group("GripPoint"):
			parent.gripPoint1.queue_free()
		parent.gripPoint1 = null
	elif parent.controller2 && parent.controller1:
		if initController == parent.controller1:
			parent.controller1 = parent.controller2
			parent.controller2 = null
			if !parent.gripPoint1.is_in_group("GripPoint"):
				parent.gripPoint1.queue_free()
			parent.gripPoint1 = parent.gripPoint2
			parent.gripPoint2 = null
		else:
			parent.controller2 = null
			if !parent.gripPoint2.is_in_group("GripPoint"):
				parent.gripPoint2.queue_free()
			parent.gripPoint2 = null
			
func make_grip(inittransform : Transform3D) -> Node3D:
	var newGrip = Node3D.new()
	add_child(newGrip)
	newGrip.global_transform = inittransform
	return newGrip


