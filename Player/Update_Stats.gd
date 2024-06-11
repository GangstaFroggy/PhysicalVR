extends Resource
class_name Updater
signal update
func emit_update():
	print("update")
	update.emit()
