extends Node3D
class_name Level

func _ready():
	load_vr()

func load_vr():
	var xr_interface : XRInterface = XRServer.find_interface("OpenXR")
	if xr_interface and xr_interface.is_initialized():
		var vp : Viewport = get_viewport()
		vp.use_xr = true
