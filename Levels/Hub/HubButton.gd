extends Area3D
@onready var next_level_path : String = "res://Levels/Level1.tscn"

func _on_area_entered(area):
	get_tree().change_scene_to_file(next_level_path)
