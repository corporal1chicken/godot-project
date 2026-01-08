extends Control

func _on_return_pressed() -> void:
	Signals.change_sub_screen.emit("about", "selection")
