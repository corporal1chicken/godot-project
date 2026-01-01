extends Control


#Likely need to change how this works. Clicking the back button shows everything
#Including the play button. Could probably exclude that since the player will
#Not need to go back to that screen. But back button isn't visible on the main
#Menu. So seperating it is likely better.



@export_category("Main Menu")
@export var available_games: Dictionary[String, PackedScene]

var selected_game: String = ""

func _ready() -> void:
	for button in $second_screen/games.get_children():
		button.pressed.connect(_on_game_pressed.bind(button))
		
		pass
	
	pass

func _on_play_pressed():
	$first_screen.visible = false
	$second_screen.visible = true
	
	pass

func _on_game_pressed(button: Button):
	selected_game = button.name
	
	if selected_game != "":
		$second_screen/confirm.disabled = false
		$second_screen/confirm.text = "continue with " + selected_game
		
		pass
	
	pass

func _on_confirm_pressed():
	if available_games.has(selected_game):
		Signals.change_screen.emit("main_menu", selected_game)
	else:
		print("game unavliable (", selected_game, ")")
		
		pass
		
	pass
	
func change_visibility(change: bool):
	for child in get_children():
		if child.name == "game_holder":
			continue
		
		child.visible = change
		
		pass
		
	pass
