extends Area3D

func _on_area_entered(_area):
	call_deferred("change_scene")

func disable():
	set_deferred("monitorable", false)
	set_deferred("monitoring", false)
	visible = false

func enable():
	set_deferred("monitorable", true)
	set_deferred("monitoring", true)
	visible = true

func change_scene():
	get_tree().change_scene_to_file("res://Levels/Hub/Hub.tscn")
