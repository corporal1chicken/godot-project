extends Control

@onready var game_selection: Control = $game_selection

func _on_play_pressed():
	$play_screen.visible = false
	$game_selection.visible = true

func _on_confirm_pressed():
	if game_selection.avaliable_games.has(game_selection.selected_game):
		Signals.change_screen.emit("main_menu", game_selection.selected_game)
	else:
		print("game invalid (", game_selection.selected_game, ")")
