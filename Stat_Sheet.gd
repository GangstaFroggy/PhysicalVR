extends Label3D

func _ready():
	display()


# Called when the node enters the scene tree for the first time.
func display():
	text = ""
	var file_read = FileAccess.open("user://savegame.data", FileAccess.READ)
	var saved_data = file_read.get_var()
	file_read.close()
	for attribute in saved_data:
		if saved_data[attribute] is float:
			text += attribute + ": " + str(saved_data[attribute]) + "\n"
