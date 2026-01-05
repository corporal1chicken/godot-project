extends Control

func _ready() -> void:
	for child in $holder.get_children():
		child.pressed.connect(_on_holder_pressed.bind(child.name))
	
	pass
	
func _on_holder_pressed(screen_name: String):
	Signals.change_sub_screen.emit("selection", screen_name)
