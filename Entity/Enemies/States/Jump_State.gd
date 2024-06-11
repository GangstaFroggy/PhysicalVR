extends State
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity") 

func enter():
	body.velocity.y += 4
	body.move_and_slide()

func process_physics(delta):
	body.velocity.y -= gravity * delta
	body.move_and_slide()
	if body.velocity.y <= 0:
		transition.emit("Fire_State")

