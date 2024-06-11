extends CharacterBody3D

# Helper variables to keep our code readable
@onready var origin_node = $XROrigin3D
@onready var camera_node = $XROrigin3D/XRCamera3D
@onready var neck = $XROrigin3D/XRCamera3D/Neck
@onready var left_controller = $XROrigin3D/LeftController
@onready var right_controller = $XROrigin3D/RightController
@onready var collision = $CollisionShape3D
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity") 

func _process_on_physical_movement(delta) -> void:
  # Remember our current velocity, we'll apply that later
	var current_velocity = velocity

	var org_player_body: Vector3 = global_transform.origin
	var player_body_location: Vector3 = neck.global_transform.origin
	player_body_location.y = org_player_body.y

	velocity = (player_body_location - org_player_body) / delta
	move_and_slide()

  # Now move our XROrigin back
	org_player_body.y = global_position.y
	var delta_movement = global_transform.origin - org_player_body
	origin_node.global_transform.origin -= delta_movement

  # Return our value
	velocity = current_velocity


#Adjust height of cylinder to height of player head
func make_collision_sphere(_delta) -> void:
	var collision_height = abs(neck.global_transform.origin.y - origin_node.global_transform.origin.y)
	collision.shape.height = collision_height
	origin_node.position.y = -collision_height/2
	
func process_gravity(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
		move_and_slide()

func _physics_process(delta):
	make_collision_sphere(delta)
	_process_on_physical_movement(delta)
	process_gravity(delta)
	
