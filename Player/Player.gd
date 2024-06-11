extends Node
class_name Player
@export var base_aspects : Array[Aspect]
@export var excluded_aspects : Array[String]
@export var updater : Updater

var stats : Dictionary = {}
var health : float = 0.0
var armor : float = 0.0

func _ready():
	updater.update.connect(update)
	if FileAccess.file_exists("user://savegame.data"):
		update()
	else:
		reset_save()
		update()
	
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
	reset_save()
	get_tree().change_scene_to_file("res://Levels/Hub/Hub.tscn")

func update():
	var file = FileAccess.open("user://savegame.data", FileAccess.READ)
	var save_data = file.get_var()
	file.close()
	stats = {}
	stats.merge(str_to_var(save_data["Player"]).variables)
	for key in stats:
		if save_data.has(key):
			stats[key] *= save_data[key]
	health = stats["health"]
	armor = stats["armor"]

func reset_save():
	var new_save = {}
	var file = FileAccess.open("user://savegame.data", FileAccess.WRITE)
	for aspect in base_aspects:
		new_save[aspect.name] = var_to_str(aspect)
		for variable in aspect.variables:
			new_save[variable] = 1.0
	for exclusion in excluded_aspects:
		new_save.erase(exclusion)
	new_save["Wave"] = type_convert(0, TYPE_INT)
	file.store_var(new_save)
	file.close()
