extends Node
class_name State
@onready var state_machine = get_parent()
@onready var body = get_parent().get_parent()
var target_position : Vector3 = Vector3.ZERO

signal transition(new_state : String)

func enter():
	pass

func exit():
	pass

func process_physics(delta):
	pass
