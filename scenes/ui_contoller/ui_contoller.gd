extends Node

# Next Feature:
# - Achievements
# - Second Minigame (Calibration Style, get a question and quickly give answer)

# Bugs/To Do
# - [✓] Some UI not changed
# - [✓] Results screen is broken
# - [✓] Quit button for midgame
# - [✓] Overlay for details on what you're playing (mode, difficulty, modifier)
# - [✓] Capitalisation for some buttons
# - [] If the pause menu is closed, whilst the control is open, bugs out
# - [] Could differentiate focus/pressed styles for buttons better
# - [] Rock Paper Scissors AI

@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var pause_menu: CanvasLayer = $pause

var current_screen: String = "main_menu"
var previous_screen: String

var game_paused: bool = false

func _ready() -> void:
	Signals.change_screen.connect(_on_change_screen)
	Signals.change_screen_from_pause.connect(_on_change_screen_from_pause)
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause_menu"):
		if current_screen == "main_menu": return
		
		_pause_game()
			
func _pause_game():
	if $AnimationPlayer.is_playing():
		await $AnimationPlayer.animation_finished
	
	if game_paused:
		$AnimationPlayer.play_backwards("open_pause_menu")
		await $AnimationPlayer.animation_finished
		pause_menu.layer = 0
		game_paused = false
		Signals.game_resumed.emit()
 
	else:
		pause_menu.layer = 10
		$AnimationPlayer.play("open_pause_menu")
		game_paused = true
		Signals.game_paused.emit()

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
	
	current_screen = new_screen
	previous_screen = old_screen

func unpause_game():
	pause_menu.visible = false
	game_paused = false
	Signals.game_resumed.emit()
	
func _on_change_screen_from_pause(new_screen: String):
	_pause_game()
	
	_on_change_screen(current_screen, "main_menu")
	Signals.change_sub_screen.emit($CanvasLayer/main_menu.current_sub_screen, new_screen)
