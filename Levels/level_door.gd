extends Area3D
class_name LevelDoor

func _process(_delta):
	if has_overlapping_bodies():
		get_tree().change_scene_to_file("res://Levels/Level1.tscn")
