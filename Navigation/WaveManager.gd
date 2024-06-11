extends Node3D
@export var player : CharacterBody3D
@export var wave_list : Array[Wave]
@export var upgrade_points : Array[Node3D]
@export var wave_counter : Label3D
@export var stat_board : Label3D
@export var return_button : Area3D
var current_wave : Wave
var spawner : EnemySpawner
var has_won : bool = false
var curr_wavetime : float = 0.0
var upgrades : Array[Upgrade] = []
var upgrade_scn = preload("res://Items/upgrade.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	return_button.disable()
	var file_read = FileAccess.open("user://savegame.data", FileAccess.READ)
	var wave_idx = file_read.get_var()["Wave"]
	file_read.close()
	current_wave = wave_list[wave_idx]
	wave_counter.text = "Wave " + var_to_str(wave_idx + 1)
	spawn_spawner(current_wave)

func _process(delta):
	if has_won != true:
		if curr_wavetime + delta >= current_wave.duration && spawner && curr_wavetime != -1:
			free_spawner()
			spawn_upgrades()
			curr_wavetime = -1
		else:
			curr_wavetime += delta

func change_wave():
	var file_read = FileAccess.open("user://savegame.data", FileAccess.READ)
	var save_data = file_read.get_var()
	file_read.close()
	print(save_data["Wave"])
	if save_data["Wave"] == wave_list.size() - 1:
		wave_counter.text = "You Win!"
		has_won = true
	else:
		save_data["Wave"] += 1
		print(save_data["Wave"])
		current_wave = wave_list[save_data["Wave"]]
		curr_wavetime = 0.0
		wave_counter.text = "Wave " + var_to_str(save_data["Wave"] + 1)
		var file_open = FileAccess.open("user://savegame.data", FileAccess.WRITE)
		file_open.store_var(save_data)
		file_open.close()
		spawn_spawner(current_wave)

func spawn_spawner(wave : Wave):
	spawner = EnemySpawner.new(wave)
	add_child(spawner)
	spawner.global_position = global_position

func spawn_upgrades():
	return_button.enable()
	stat_board.visible = true
	stat_board.display()
	upgrades = []
	for point in upgrade_points:
		var upgrade_instance = upgrade_scn.instantiate()
		upgrade_instance.upgrade_collected.connect(on_upgrade_collected)
		upgrades.append(upgrade_instance)
		point.add_child(upgrade_instance)

func on_upgrade_collected():
	return_button.disable()
	stat_board.visible = false
	for upgrade in upgrades:
		upgrade.queue_free()
	upgrades = []
	change_wave()

func free_spawner():
	spawner.queue_free()



