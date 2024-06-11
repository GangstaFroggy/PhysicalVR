extends Area3D

@onready var controller: XRController3D = get_parent()
@export var controllerNode: Node3D
var grabbedArea:Node3D = null

	
func _process(_delta):
	if controller.get_float("grab") > 0.3 && grabbedArea == null:
		on_grip()
	if controller.get_float("grab") > 0.3 && grabbedArea:
		if grabbedArea is TriggerGrip:
			grabbedArea.carry_input(controller)
	if controller.get_float("grab") <= 0.3 && grabbedArea:
		on_release()

func on_grip():
	if has_overlapping_areas():
		var objects = get_overlapping_areas()
		for object in objects:
			if object is Grip && grabbedArea == null:
				object.grab(controllerNode)
				grabbedArea = object

func on_release():
	grabbedArea.release(controllerNode)
	grabbedArea = null

