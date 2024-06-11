extends TriggerGrip
@export var muzzle:Node3D
@export var bullet_mesh : Mesh
@onready var cooldown : Timer = Timer.new()
@export var updater : Updater
var stats = {}
var save_data = {}

func _ready():
	updater.update.connect(update)
	update()
	add_child(cooldown)
	cooldown.one_shot = true

func carry_input(input : XRController3D):
	if input.get_float("trigger") > 0.1 && cooldown.is_stopped():
		if save_data.has("Volley"):
			var volley = save_data["Volley"]
			for projectile in int(str_to_var(volley).variables["projectiles"] * save_data["projectiles"]):
				fire()
		else:
			fire()
		cooldown.start(get_cooldown(stats["fire rate"]))

func update():
	var file = FileAccess.open("user://savegame.data", FileAccess.READ)
	save_data = file.get_var()
	file.close()
	stats = {}
	stats.merge(str_to_var(save_data["Gun"]).variables)
	for key in stats:
		if save_data.has(key):
			stats[key] *= save_data[key]

func fire():
	if save_data.has("Volley"):
		var grouping = str_to_var(save_data["Volley"]).variables["grouping"] * save_data["grouping"]
		var spread = 2.0/grouping
		var spread_vector = Vector3(randf_range(-spread, spread), randf_range(-spread, spread), randf_range(-spread, spread))
		var direction = -muzzle.global_transform.basis.z
		var bullet = Bullet.new(bullet_mesh, stats["velocity"], stats["duration"], stats["damage"], (direction + spread_vector).normalized(), save_data)
		muzzle.add_child(bullet)
	else:
		var direction = -muzzle.global_transform.basis.z
		var bullet = Bullet.new(bullet_mesh, stats["velocity"], stats["duration"], stats["damage"], direction, save_data)
		muzzle.add_child(bullet)

func get_cooldown(custom_fire_rate : float) -> float:
	return 1 / custom_fire_rate

