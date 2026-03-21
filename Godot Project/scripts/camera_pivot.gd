# CameraOrbital.gd
# Coloque esse script em um Node3D que será o "pivot" da câmera
# Estrutura recomendada na cena:
#
#   Pivot (Node3D)  ← esse script aqui
#   └─ Camera3D

extends Node3D

@export var sensitivity : float = 0.005       # sensibilidade (quanto menor = mais lento)
@export var zoom_speed : float = 0.8
@export var min_distance : float = 1.5
@export var max_distance : float = 40.0

@onready var camera : Camera3D = $Camera3D

var distance : float = 10.0
var yaw : float   = 0.0     # horizontal (esquerda/direita)
var pitch : float = 0.4     # vertical (cima/baixo)  — valor inicial um pouco inclinado

var middle_button_pressed := false


func _ready():
	# Começa olhando um pouco para baixo
	update_camera_position()


func _input(event: InputEvent) -> void:
	# Detecta botão do meio pressionado/solto
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_MIDDLE:
			middle_button_pressed = event.pressed
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED if middle_button_pressed else Input.MOUSE_MODE_VISIBLE)
	
	# Movimento só acontece com botão do meio pressionado
	if not middle_button_pressed:
		return
	
	# Rotação com mouse (só quando middle button está pressionado)
	if event is InputEventMouseMotion:
		yaw   -= event.relative.x * sensitivity
		pitch += event.relative.y * sensitivity
		
		# Limita o ângulo vertical (pra não dar cambalhota)
		pitch = clamp(pitch, -1.4, 1.4)   # ≈ ±80 graus
		
		update_camera_position()
	
	# Zoom com scroll (funciona mesmo sem segurar o botão do meio)
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			distance -= zoom_speed
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			distance += zoom_speed
		
		distance = clamp(distance, min_distance, max_distance)
		update_camera_position()


func update_camera_position() -> void:
	# Calcula a posição da câmera em coordenadas esféricas
	var direction = Vector3()
	
	direction.x = cos(pitch) * sin(yaw)
	direction.y = sin(pitch)
	direction.z = cos(pitch) * cos(yaw)
	
	# Aplica distância
	camera.position = direction * distance
	
	# Faz a câmera sempre olhar pro centro (pivot)
	camera.look_at(Vector3.ZERO, Vector3.UP)
