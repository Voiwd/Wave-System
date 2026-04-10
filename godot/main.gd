extends Node3D

@export var current_wave : WaveObject
var my_callback = JavaScriptBridge.create_callback(_set_properties)

func _ready() -> void:
	var bridge = connect_to_js()


func _set_properties(args):
	if args.size() == 0:
		return
	
	var received = args[0]
	
	if received is String:
		var data = JSON.parse_string(received)
		for k in data:
			if k  in current_wave:
				print("set ", k, " to ", data[k], " in ", current_wave.name)
				current_wave.set(k, data[k])
			else:
				print("Any key ", k, " in ", current_wave.name)

func connect_to_js():
	var bridge = JavaScriptBridge.get_interface("GodotBridge")
	if bridge:
		bridge.setproperties = my_callback
		var response = bridge.ping()
		print("JS reply: ", response)
		return bridge
	else:
		print("GodotBridge interface not found")
		return false
