extends Node3D

@export var current_wave : WaveObject

func get_type_as_string(value: Variant) -> String:
	if value == null:
		return "Null"
	
	var type_id = typeof(value)
	
	var type_name = type_string(type_id)
	
	if type_id == TYPE_OBJECT and value is Object:
		return value.get_class()
	
	return type_name

func _ready() -> void:
	connect_to_js()

func _set_properties(props : Dictionary):
	for k in props:
		if k in current_wave:
			print("set ", k, " to ", props[k], " in ", current_wave.name)
			current_wave.set(k, props[k])

func connect_to_js():
	var bridge = JavaScriptBridge.get_interface("GodotBridge")
	if bridge:
		var response = bridge.ping()
		print("JS reply: ", response)
	else:
		print("GodotBridge interface not found")
