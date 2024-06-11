extends Node
class_name StateMachine

@export var initial_state : State
@onready var body : CharacterBody3D = get_parent()
@onready var entity_main : Node3D = get_parent().get_parent().get_parent()
@onready var current_state : State
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var player : Node3D = null

func _ready():
	current_state = initial_state
	current_state.transition.connect(on_transition)
	for entity in entity_main.get_children():
		if entity.is_in_group("player"):
			player = entity
	

func _physics_process(delta):
	current_state.process_physics(delta)
	if body.velocity != Vector3.ZERO:
		body.move_and_slide()

func on_transition(new_state):
	#call exit on old state / switch current state to new state / call enter on new state
	current_state.exit()
	current_state.transition.disconnect(on_transition)
	current_state = find_child(new_state)
	current_state.transition.connect(on_transition)
	current_state.enter()
