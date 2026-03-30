extends Node3D

func _ready() -> void:
	connect_to_js()


func connect_to_js():
	if not JavaScriptBridge:
		print("JSB not available")
		return
	
	var bridge = JavaScriptBridge.get_interface("GodotBridge")
	if bridge:
		var response = bridge.ping()
		print("JS reply: ", response)
	else:
		print("GodotBridge interface not found")
