extends Area3D

func _on_area_entered(area):
	var player = area.get_parent().get_parent().get_parent().get_child(0)
	player.call_deferred("die")
