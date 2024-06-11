extends EnemyWeapon
@export var area : Area3D
@export var stats : Aspect
@onready var cooldown : Timer = Timer.new()

func _ready():
	add_child(cooldown)
	cooldown.one_shot = true

func attack(target : Vector3):
	if area.has_overlapping_areas():
		for hitbox in area.get_overlapping_areas():
			if cooldown.is_stopped():
				hitbox.apply_damage(stats.variables["damage"])
				cooldown.start(stats.variables["cooldown"])

