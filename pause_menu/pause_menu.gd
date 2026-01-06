extends Control

@export var ui_controller: Control

@onready var text_label: RichTextLabel = $inner/text_label
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var is_inner_out: bool = false

func _ready() -> void:
	Signals.set_controls.connect(_change_inner_text)
	
func _change_inner_text(new_text: String):
	text_label.text = new_text
	
func _on_resume_pressed():
	ui_controller.unpause_game()
	
	pass
	
func _on_menu_pressed():
	Signals.change_screen_from_pause.emit("selection")
	pass
	
func _on_controls_pressed():
	if animation_player.is_playing():
		await animation_player.animation_finished
	
	if is_inner_out:
		animation_player.play_backwards("inner_out")
		is_inner_out = false
	else:
		animation_player.play("inner_out")
		is_inner_out = true
	pass
	
func _on_settings_pressed():
	Signals.change_screen_from_pause.emit("settings")
	pass
	
func _on_quit_pressed():
	get_tree().quit()
