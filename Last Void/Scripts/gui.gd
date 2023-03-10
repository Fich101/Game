extends Control

func set_action_name(name):
	$action_name.text = name

var check = true
var pause = true

func _ready():
	G.root_gui = self

func alert(msg):
	$alert/text.text = msg
	$alert/show.play("show")

func show_hp(i):
	if i < 30:
		$hp/AnimationPlayer.play("hp_low", 1)
	else:
		$hp/AnimationPlayer.play("hp_norm", 1)

func stamina_bar(i):
	$stamina_bar.value = i
	if $stamina_bar.value < 90:
		$stamina_bar.show()
	else:
		$stamina_bar.hide()

func _physics_process(delta):
	if !G.action_object:
		set_action_name('')
	elif G.action_object && 'action_name' in G.action_object:
		set_action_name(G.action_object.action_name)

func show_charge(i):
	$charge_bar.value = i
	$charge_bar.show()

func hide_charge():
	$charge_bar.hide()

func read_show(i):
	$sheet.show()
	$sheet/sheet_text.text = i
	check = false

func read_hide():
	if $sheet.visible:
		$sheet.hide()
		check = true

func show_pause():
	$pause.show()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	pause = false

func hide_pause():
	$pause.hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pause = true
