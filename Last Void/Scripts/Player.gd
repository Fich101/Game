extends KinematicBody

const VEL_SPEED = 3
const GRAVITY = -20
const JUMP_SPEED = 8
const ROT_SPEED = 0.004

onready var head = $head
onready var body = $collision
onready var flash = $head/SpotLight
onready var anim = $head/Camera/AnimationPlayer

var rot_y = 0
var rot_x = 0
var vel = Vector3()
var crouch = false
var torch = false
var state = 'idle_camera'
var first_item = false
var arms
var arms_visible = null
export var HP = 100
var flash_charge = 100
var stamina = 100

func action():
	if G.action_object:
		G.action_object.call('action')

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	G.charge = flash_charge
	if arms == $head/flashlight && arms_visible == true:
		G.show_charge(flash_charge)
	else:
		G.hide_charge()
	G.show_hp(HP)
	G.stamina_bar(stamina)
	stamina += 0.1
	if stamina > 100:
		stamina = 100
	if stamina < 0:
		stamina = 0
	if $head/SpotLight.visible:
		charge_down()
	var dir = Vector3()
	var need_state = ''
	var need_anim = ''
	if Input.is_action_pressed("ui_up"):
		if crouch == false:
			dir.z = -2
			need_state = 'Walk_camera'
		else:
			dir.z = -1
			need_state = 'idle_camera'
		if HP < 40:
			dir.z = -1
			need_state = 'Walk_camera'
		
	if Input.is_action_pressed("ui_down"):
		if crouch == false:
			dir.z = 2
		else:
			dir.z = 1
		if HP < 40:
			dir.z = 1

	if Input.is_action_pressed("ui_left"):
		if crouch == false:
			dir.x = -2
		else:
			dir.x = -1
		if HP < 40:
			dir.x = -1

	if Input.is_action_pressed("ui_right"):
		if crouch == false:
			dir.x = 2
		else:
			dir.x = 1
		if HP < 40:
			dir.x = 1

	if Input.is_action_just_pressed("ui_reload"):
		if G.is_inv('battery'):
			G.recharge()
			G.inv.erase('battery')
			flash_charge = G.charge

	if Input.is_action_just_pressed("ui_inv_1"):
			if G.is_inv('flash'):
				if first_item == false:
					arms = $head/flashlight
					arms.show()
					first_item = true
					arms_visible = true
				else:
					arms.hide()
					first_item = false
					arms_visible = false
					$head/SpotLight.hide()

	if Input.is_action_just_pressed("ui_flash"):
		if arms == $head/flashlight && arms_visible == true:
			light()
	
	if Input.is_action_just_pressed("ui_right_click"):
		print(G.inv)

	if Input.is_action_just_pressed("ui_use"):
		action()

	if Input.is_action_just_pressed("ui_select"):
		if is_on_floor():
			if crouch == false:
				vel.y = JUMP_SPEED
			else:
				vel.y = 0
	if Input.is_action_pressed("ui_sprint"):
		if crouch == false && HP > 20 && stamina > 0:
			if Input.is_action_pressed("ui_up"):
				dir.z = -4
				stamina -= 0.3
		else:
			if Input.is_action_pressed("ui_up"):
				dir.z = -2
				stamina -= 0.5
		if stamina <= 0 && HP <= 20 :
			if Input.is_action_pressed("ui_up"):
				dir.z = -2
				stamina -= 0.5
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
	vel = move_and_slide(vel, Vector3.UP)
	
	if !need_state: need_state = 'idle_camera'
	set_state(need_state, need_anim)

func _input(e):
	if e is InputEventMouseMotion:
		rot_x -= e.relative.y * ROT_SPEED
		rot_y -= e.relative.x * ROT_SPEED
		if rot_x > 1.2: rot_x = 1.2
		if rot_x < -1.2: rot_x = -1.2
		transform.basis = Basis(Vector3(0, 1, 0), rot_y)
		head.transform.basis = Basis(Vector3.RIGHT, rot_x)
		
func light():
		if torch == true:
			$head/SpotLight.hide()
			HP = 100
			torch = false
		else:
			$head/SpotLight.show()
			HP = 5
			torch = true

func set_state(s, a = ''):
	if !s || state == s: return
	state = s
	if !a: a = s
	if anim.current_animation == a: return
	anim.play(a, 0.2)

func charge_down():
	if flash_charge > 0:
		flash_charge -= 0.01
	if flash_charge < 0:
		flash_charge = 0
	if flash_charge > 100:
		flash_charge = 100
	if flash_charge <= 0:
		$head/SpotLight.hide()
		torch = false
