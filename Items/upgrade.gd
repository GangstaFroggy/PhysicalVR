extends Area3D
class_name Upgrade

@export var enhancements : Array[Aspect]
@export var updater : Updater
var can_enhance : bool = false
var enhancement : Resource = null
@onready var label : Label3D = $Label3D
var upgrades : Dictionary = {}
signal upgrade_collected

func _ready():
	var file_read = FileAccess.open("user://savegame.data", FileAccess.READ)
	var saved_data = file_read.get_var()
	file_read.close()
	area_entered.connect(on_area_entered)

	var count : int = 0
	for enhance in enhancements:
		for key in saved_data:
			if key == enhance.name:
				count+=1
	if count < 2:
		can_enhance = true

	if can_enhance:
		var type_upgrade : int = randi_range(0, 1)
		if type_upgrade == 0:
			enhancement = enhancements[randi_range(0, enhancements.size() - 1)]
		else:
			make_upgrades(saved_data)
	else:
		make_upgrades(saved_data)

	if enhancement:
		label.text += var_to_str(enhancement.name)
	else:
		for upgrade in upgrades:
			label.text += upgrade + ": " + str(upgrades[upgrade]) + "\n"

func make_upgrades(saved_data : Dictionary):
	var keys = []
	for key in saved_data:
		if saved_data[key] is float:
			keys.append(key)
	var up1 = keys[randi_range(0, keys.size() - 1)]
	var up2 = keys[randi_range(0, keys.size() - 1)]
	var rand_ups = [up1, up2]
	
	for upgrade in rand_ups:
		var rand_up = randfn(1.1, .2)
		rand_up = snappedf(rand_up, 0.05)
		rand_up = clampf(rand_up, 1.1, 1.5)
		if upgrade in upgrades:
			upgrades[upgrade] += rand_up - 1
		else:
			upgrades[upgrade] = rand_up

func on_area_entered(_area:Area3D):
	var file_read = FileAccess.open("user://savegame.data", FileAccess.READ)
	var saved_data = file_read.get_var()
	file_read.close()
	for variable in upgrades:
		saved_data[variable] *= upgrades[variable]
	if enhancement && !enhancement.name in saved_data:
		saved_data[enhancement.name] = var_to_str(enhancement)
		saved_data.merge(enhancement.variables)
		for variable in enhancement.variables:
			saved_data[variable] = 1.0

	var file_open = FileAccess.open("user://savegame.data", FileAccess.WRITE)
	file_open.store_var(saved_data)
	file_open.close()

	upgrade_collected.emit()
	updater.emit_update()
	queue_free()
