extends KinematicBody
var accel = 8 #ускорение
var speed = 12 #скорость 
var jump = 9 #сила прыжка
var sens = 0.1 #чувствительность камеры
var _delta #дельта для фикса фпс
 
var direction = Vector2() #направление
var vel = Vector3() #скорость
 
var gravity = -22 #гравитация
var max_grav = -30 #максимальная скорость падения
 
onready var head = $head
 
 
#func _ready():
	#ЗАХВАТЫВАЕМ КУРСОС ЧТОБЫ СМОТРЕТЬ
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
 
func _physics_process(delta):
	#ВЫЗЫВАЕМ ФУНКЦИЮ ДВИЖЕНИЯ
	_delta = delta #определяем дельта для функций
	dir()
 
#ФУНКЦИЯ СМОТРЕНИЯ
func _input(event):
	#если эвент = движение мыши то:
	if event is  InputEventMouseMotion:
		var movement = event.relative
		#поворот вверх и вниз (только голову)
		head.rotation.x += -deg2rad(movement.y * sens)
		#чтобы не делать бэкфлип
		head.rotation.x = clamp(head.rotation.x , deg2rad(-90), deg2rad(90))
		#поворот вправо влево
		rotation.y += -deg2rad(movement.x * sens)
		
		
#функция движения
func dir():
	direction = Vector2(0,0)
#определяем в какую сторону идти
	if Input.is_action_pressed("+w"):
		direction.y -= 1
	elif Input.is_action_pressed("+s"):
		direction.y += 1
	if Input.is_action_pressed("+a"):
		direction.x -= 1
	elif Input.is_action_pressed("+d"):
		direction.x += 1
#нормализуем чтобы направление не сбивалось
	direction = direction.normalized().rotated(-rotation.y)
#вычисляем скорость с помощью направления
	vel.x = lerp(vel.x, direction.x * speed, accel * _delta)
	vel.z = lerp(vel.z, direction.y * speed, accel * _delta)
	
#гравитация в ход
	vel.y += gravity * _delta
	
#чтобы слишком сильно не улетать
	if vel.y < max_grav:
		vel.y = max_grav
#если мы на земле и нажимаем пробел то:
	if Input.is_action_just_pressed("+space") and is_on_floor():
		vel.y = jump #прыжок
	
	move_and_slide(vel,Vector3.UP) #двигаемся
	
	if is_on_floor() and vel.y < 0: #если мы стоим на полу значит мы не падаем :D
		vel.y = 0
