extends Area3D
class_name PlayerHitBox
@export var player : Player
	
func apply_damage(damage : float):
	if player.armor >= damage:
		player.armor -= damage
	else:
		player.health -= 1
		player.armor = 0.0
