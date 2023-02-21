extends KinematicBody

const rot_speed = 0.01
const gr = -20
const speed = 200
const jump_speed = 8
var vel = Vector3()
var state = 'Idle'
onready var anim = $AnimationPlayer
onready var cam = $Cam
onready var collision = $CollisionShape
onready var body = $Body
var check = false

var rot_x = 0
var rot_y = 0

var need_state = ''
var need_anim = '' 

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	var dir = Vector3()
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	if Input.is_action_pressed("ui_left"):
		dir.x = 1
	if Input.is_action_pressed("ui_right"):
		dir.x = -1
	if Input.is_action_pressed("ui_up"):
		dir.z = 1
	if Input.is_action_pressed("ui_down"):
		dir.z = -1
	if Input.is_action_pressed("ui_sprint"):
		if Input.is_action_pressed("ui_up"):
			dir.z = 2
	if Input.is_action_just_pressed("ui_crawl"):
		if check == false:
			cam.translate(Vector3(0, -0.7, 0))
			body.translate(Vector3(0, +0.5, 0))
			collision.scale = Vector3(0.6, 0.4, 0.5)
			check = true
		else:
			cam.translate(Vector3(0, +0.7, 0))
			body.translate(Vector3(0, -0.5, 0))
			collision.scale = Vector3(0.6, 0.8, 0.9)
			check  = false

	need_state = ''

	if dir:
		need_state = 'Move'
		dir *= speed * delta
		dir = dir.rotated(Vector3(0, 1, 0), rotation.y)

	vel.x = dir.x
	vel.z = dir.z

	if Input.is_action_just_pressed("ui_select"):
		if is_on_floor():
			vel.y = jump_speed

	vel.y += gr * delta

	vel = move_and_slide(vel, Vector3(0, 1, 0))

	if !need_state: need_state = 'Idle'
	set_state(need_state, need_anim)

func _input(e):
	if e is InputEventMouseMotion:
		rot_y -= e.relative.x * rot_speed
		rot_x -= e.relative.y * rot_speed
		
		if rot_x < -1.2: rot_x = -1.2
		if rot_x > 1.2: rot_x = 1.2
		
		transform.basis = Basis(Vector3(0, 1, 0), rot_y)
		$Cam/Camera.transform.basis = Basis(Vector3(1, 0, 0), rot_x)

func set_state(s, a =''):
	if !s || state == s: return
	state = s
	if !a : a = s
	if anim.current_animation == a: return
	anim.play(a, 0.3)
