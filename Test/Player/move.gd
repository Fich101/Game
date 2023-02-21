extends KinematicBody
const speed = 100
func _physics_process(delta):
	var dir = Vector3()
	if Input. is_action_just_pressed("ui_left"):
		dir.x = -1
	if Input. is_action_just_pressed("ui_right"):
		dir.x = 1
	if Input. is_action_just_pressed("ui_up"):
		dir.z = -1
	if Input. is_action_just_pressed("ui_down"):
		dir.x = 1
	if dir *= SPEED * delta
	move_and_slide(dir, Vector3(0,1,0))
