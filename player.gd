extends KinematicBody

onready var head = $head
onready var camera = $head/Camera
#onready var gun_pos = $head/Camera/hand.translation #ṕpostition3d irá definir a posiçao de qualquer arma que o jogador pegue
#onready var gun = $head/Camera/gun
onready var animator = $head/Camera/animation
#------------------------------------_________________------------------------#
export var speed = 20 #velocidade que o jogador irá andar em alguma direção
export var acceleration = 15 # a taxa que ele vai acelerar
export var jump_acceleration = 0 # a taxa de aceleração do pulo
export var mouse_sensitivity = 0.3
#------------------------------------_________________------------------------#
var velocity = Vector3() #o vetor de velocidade
var camera_x_rotation = 0 # rotação em x da câmera
var jump_power = 20 #podeer máximo de pulo
var jump_timer = 0 #Temporizador do pulo
var dash_timer = 0
var gravity = 4.5
var jump_counter = 0 # quantas vezes ele pula
var jumping = 0  #Definir se o jogador pode planar ou não
var direction
#------------------------------------_________________------------------------#
func pulo(): # função de pulo suave
	jump_acceleration += jump_power
	velocity.y = jump_power
	animator.play("jump")

func planagem(): # função para planagem
	velocity.y -= gravity
	gravity = 0.5
#------------------------------------_________________------------------------#
func _ready(): #função para preparação dos coisos
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
#	gun.set_translation(gun_pos) # defubur a posição da arma
	
func _input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(deg2rad(-event.relative.x * mouse_sensitivity)) # faze a câmera rotaciona pros lados baseado na última posiçãõ do mouse
		var x_delta = event.relative.y * mouse_sensitivity

		if camera_x_rotation + x_delta > -90 and camera_x_rotation + x_delta < 90:
			camera.rotate_x(deg2rad(-x_delta))
			camera_x_rotation += x_delta
			#aplicar limite para a rotaçõ em y do mouse
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"): #poder sair do jogo
		get_tree().quit()
#------------------------------------_________________------------------------#
func _physics_process(delta):
	var head_basis = head.get_global_transform().basis # pegar a direçao da visão do jogador
	var direction = Vector3()
	
	if Input.is_action_pressed("move_foward"): # dá pra entender
		direction -= head_basis.z
	elif Input.is_action_pressed("move_backward"):
		direction += head_basis.z
	if Input.is_action_pressed("move_left"):
		direction -= head_basis.x
	if Input.is_action_pressed("move_right"):
		direction += head_basis.x
	if (direction.x != 0) or (direction.z != 0):
		animator.play("moving")
	else:
		animator.stop()
	direction = direction.normalized()
	# interpolação para deixar o movimento de andar mais suave
	velocity = velocity.linear_interpolate(direction * speed, acceleration * delta)
	velocity.y -= gravity
	
	if Input.is_action_pressed("Jump") and jump_acceleration <= 700 and jump_counter < 1:
		# se o botão de pulo for ativado e o pico do pulo ainda não foi atingido
		pulo()
		jump_timer += delta # tempo que o botão de pulo é ativado
		jumping = 1
		animator.play("jump")
	if jump_timer >= 0.6 and jumping == 1: # ativar função de planagem
		planagem()
	if Input.is_action_just_released("Jump"): # retornar aos valores normais de gravidade e talz
		jump_counter = 1
		jumping = 0
		gravity = 4.5
	elif is_on_floor():
		jump_acceleration = 0
		jump_timer = 0
		jump_counter = 0
	velocity = move_and_slide(velocity, Vector3.UP)
	print(speed)
