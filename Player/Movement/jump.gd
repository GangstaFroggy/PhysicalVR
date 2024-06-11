extends Node
class_name JumpModule

@onready var controller : XRController3D = get_parent()
@onready var body : CharacterBody3D = get_parent().get_parent().get_parent()
@export var player: Player

func _physics_process(_delta):
	if controller.is_button_pressed("primary_button") and body.is_on_floor():
		body.velocity.y = player.stats["agility"]
		body.move_and_slide()
