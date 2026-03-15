extends Node3D

@export var skeleton3d : Skeleton3D
@export var amplitude : float = .25
@export var frequency : float = 2
@export var wave_length : float = 6
@export var phase : float
var _time : float

var bone_count : int

func _senoidal_wave(x, t):
	return amplitude * sin((2*PI/ wave_length) * x + frequency * t + phase)
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bone_count = skeleton3d.get_bone_count()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_time += delta
	
	for idx in range(bone_count):
		var bone_position = skeleton3d.get_bone_pose_position(idx)
		var height = _senoidal_wave(bone_position.x, _time)
		bone_position.y = height
		skeleton3d.set_bone_pose_position(idx, bone_position)
