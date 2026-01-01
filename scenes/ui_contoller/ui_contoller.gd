extends Node

@onready var canvas_layer: CanvasLayer = $CanvasLayer

func _ready() -> void:
	Signals.change_screen.connect(_on_change_screen)

func _on_change_screen(old_screen: String, new_screen: String):
	var old_child: Control = canvas_layer.get_node_or_null(old_screen)
	
	if not old_child: 
		print("no child found for (old) ", old_screen) 
		return
	
	var new_child: Control = canvas_layer.get_node_or_null(new_screen)
	
	if not new_child: 
		print("no child found for (new) ", new_screen) 
		return
	
	old_child.visible = false
	new_child.visible = true
