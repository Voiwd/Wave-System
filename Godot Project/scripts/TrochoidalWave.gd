extends Node3D

@export var amplitude : float = .3
@export var direction : Vector2 = Vector2(1, 0).normalized()
@export var steepness : float = .35
@export var wavelength : float = 2     
@export var angular_frequency : float = 3.2
@export var phase : float = 0.0

@onready var skeleton3d: Skeleton3D = $WaveArmature/Skeleton3D

var scene_time = 0.0
var bone_count = 0

func _trochoidal_wave(x: float, y: float, z: float, t: float) -> Vector3:
	var k = 2.0 * PI / wavelength
	
	var dot = k * (direction.x * x + direction.y * z)
	var W = dot - angular_frequency * t + phase
	
	var horizontal_x = x + steepness * amplitude * direction.x * cos(W)
	var vertical_y   = amplitude * sin(W)
	var horizontal_z = z + steepness * amplitude * direction.y * cos(W)
	
	return Vector3(horizontal_x, vertical_y, horizontal_z)

func _ready() -> void:
	bone_count = skeleton3d.get_bone_count()

func _process(delta: float) -> void:
	scene_time += delta
	
	for idx in range(bone_count):
		var rest_transform = skeleton3d.get_bone_rest(idx)
		var rest_pos = rest_transform.origin
		
		var new_pos = _trochoidal_wave(rest_pos.x, rest_pos.y, rest_pos.z, scene_time)
		
		skeleton3d.set_bone_pose_position(idx, new_pos)
