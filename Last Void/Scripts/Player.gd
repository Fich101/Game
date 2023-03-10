extends CharacterBody3D

const VEL_SPEED = 2
const GRAVITY = -20
const JUMP_SPEED = 8
const ROT_SPEED = 0.004

@onready var head = $head
@onready var body = $collision
@onready var flash = $head/SpotLight3D
@onready var anim = $head/Camera3D/AnimationPlayer

var rot_y = 0
var rot_x = 0
var vel = Vector3()
var crouch = false
var torch = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	var dir = Vector3()
	if Input.is_action_pressed("ui_up"):
		if crouch == false:
			dir.z = -2
		else:
			dir.z = -1
	if Input.is_action_pressed("ui_down"):
		if crouch == false:
			dir.z = 2
		else:
			dir.z = 1
	if Input.is_action_pressed("ui_left"):
		if crouch == false:
			dir.x = -2
		else:
			dir.x = -1
	if Input.is_action_pressed("ui_right"):
		if crouch == false:
			dir.x = 2
		else:
			dir.x = 1

	if Input.is_action_just_pressed("ui_left_click"):
		light()

	if Input.is_action_just_pressed("ui_select"):
		if is_on_floor():
			if crouch == false:
				vel.y = JUMP_SPEED
			else:
				vel.y = 0
	if Input.is_action_pressed("ui_sprint"):
		if crouch == false:
			if Input.is_action_pressed("ui_up"):
				dir.z = -4
		else:
			if Input.is_action_pressed("ui_up"):
				dir.z = -2
	if Input.is_action_just_pressed("ui_crouch"):
		if crouch == false:
			body.scale = Vector3(0.7, 0.7, 1)
			head.translate(Vector3(0, -1, 0))
			crouch = true
		else:
			body.scale = Vector3(1, 1, 3)
			head.translate(Vector3(0, +1, 0))
			crouch = false

	if vel:
		dir = dir.rotated(Vector3.UP, rot_y) * VEL_SPEED

	vel.x = dir.x
	vel.z = dir.z
	vel.y += GRAVITY * delta
	set_velocity(vel)
	set_up_direction(Vector3.UP)
	move_and_slide()
	vel = velocity


func _input(e):
	if e is InputEventMouseMotion:
		rot_x -= e.relative.y * ROT_SPEED
		rot_y -= e.relative.x * ROT_SPEED
		if rot_x > 1.2: rot_x = 1.2
		if rot_x < -1.2: rot_x = -1.2
		transform.basis = Basis(Vector3(0, 1, 0), rot_y)
		head.transform.basis = Basis(Vector3.RIGHT, rot_x)
		
func light():
	if Input.is_action_just_pressed("ui_left_click"):
		if torch == false:
			$head/SpotLight3D.hide()
			torch = true
		else:
			$head/SpotLight3D.show()
			torch = false
