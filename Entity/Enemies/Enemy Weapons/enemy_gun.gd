extends EnemyWeapon
class_name EnemyGun
@export var stats : Aspect
@export var muzzle : Node3D
@export var bullet_mesh : Mesh
@export var aspects : Array[Aspect]
@onready var cooldown : Timer = Timer.new()
var data : Dictionary = {}

func _ready():
	add_child(cooldown)
	cooldown.one_shot = true
	cooldown.start(get_cooldown(stats.variables["fire rate"]))
	for aspect in aspects:
		data[aspect.name] = var_to_str(aspect)
		data.merge(aspect.variables)
		for variable in aspect.variables:
			data[variable] = 1.0

func attack(target : Vector3):
	if cooldown.is_stopped():
		if data.has("Volley"):
			var volley = data["Volley"]
			for projectile in int(str_to_var(volley).variables["projectiles"] * data["projectiles"]):
				fire(muzzle.global_position.direction_to(target), stats.variables["velocity"], stats.variables["duration"], stats.variables["damage"], data)
		else:
			fire(muzzle.global_position.direction_to(target), stats.variables["velocity"], stats.variables["duration"], stats.variables["damage"], data)
		cooldown.start(get_cooldown(stats.variables["fire rate"]))

func fire(bullet_direction : Vector3, bullet_velocity:float, bullet_duration:float, bullet_damage:float, saved_data : Dictionary = {}):
	if saved_data.has("Volley"):
		var grouping = str_to_var(saved_data["Volley"]).variables["grouping"] * saved_data["grouping"]
		var spread = 1.0/grouping
		var spread_x = randf_range(-spread, spread)
		var spread_y = randf_range(-spread, spread)
		var spread_z = randf_range(-spread, spread)
		var spread_vector = Vector3(spread_x, spread_y, spread_z)
		var bullet = Bullet.new(bullet_mesh, bullet_velocity, bullet_duration, bullet_damage, (bullet_direction + spread_vector).normalized(), saved_data)
		muzzle.add_child(bullet)
	else:
		var bullet = Bullet.new(bullet_mesh, bullet_velocity, bullet_duration, bullet_damage, bullet_direction, saved_data)
		muzzle.add_child(bullet)

func get_cooldown(custom_fire_rate : float) -> float:
	return 1 / custom_fire_rate
