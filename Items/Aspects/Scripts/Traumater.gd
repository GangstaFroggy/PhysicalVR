extends Node
class_name Traumater

var tick = 0.0
var tick_damage = 0.0
var current_tick = 0.0

func _init(init_tick : float, init_tick_damage : float):
	tick = init_tick
	tick_damage = init_tick_damage

func _process(delta):
	current_tick += delta
	if current_tick > tick:
		get_parent().apply_damage(tick_damage)
		current_tick = 0.0
