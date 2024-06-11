extends Node
class_name Entity

@export var base_stats : Aspect
@onready var stats : Dictionary = base_stats.variables
@onready var health = stats["health"]
@onready var armor = stats["armor"]
@onready var regen = stats["regen"]

func _process(delta):
	var armor_difference = stats["armor"] - armor
	var frame_regen = stats["regen"] * delta
	if stats["armor"] != armor:
		if armor_difference < frame_regen:
			armor = stats["armor"]
		else:
			armor += frame_regen
	if health <= 0:
		die()

func die():
	queue_free()
