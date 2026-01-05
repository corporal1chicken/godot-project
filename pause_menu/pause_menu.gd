extends Control

@export var ui_controller: Control

func _ready() -> void:
	pass
	
func _on_resume_pressed():
	ui_controller.unpause_game()
	pass
	
func _on_menu_pressed():
	Signals.change_screen_from_pause.emit("selection")
	pass
	
func _on_settings_pressed():
	Signals.change_screen_from_pause.emit("settings")
	pass
	
func _on_quit_pressed():
	get_tree().quit()
