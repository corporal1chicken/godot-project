extends Node

# Could likely set a current_gamemode with a match function
# Could create gamemode start and end functions
# i.e. comeback_start() that sets AI points to 3

var gamemode_info: Dictionary
var modifier_info: Dictionary

func _gamemode_edit(game_stats: Dictionary):
	if gamemode_info.get("starting_points"):
		game_stats.computer_score = gamemode_info.get("starting_points")
		
	if gamemode_info.get("points_on_win"):
		game_stats.points_on_win = gamemode_info.get("points_on_win")
	
	if gamemode_info.get("points_on_loss"):
		game_stats.points_on_loss = gamemode_info.get("points_on_loss")
	
	return game_stats
	
func _modifier_edit(game_stats: Dictionary):
	var key = modifier_info.get("key")
	
	if key == "double_points":
		game_stats.points_on_win *= 2
	elif key == "lock_input":
		game_stats["lock_input"] = true
	
	return game_stats

func edit_game_stats(default_game_stats: Dictionary) -> Dictionary:
	var new_game_stats: Dictionary = default_game_stats.duplicate()
	
	var gamemode_edit_stats = _gamemode_edit(new_game_stats)
	var modifier_edit_stats = _modifier_edit(gamemode_edit_stats)
	
	return modifier_edit_stats

func set_game_info(gamemode: Dictionary, modifier: Dictionary):
	gamemode_info = gamemode
	modifier_info = modifier

func check_rules(state: Dictionary) -> Array:
	
	if gamemode_info.key == "best_of":
		if state.rounds_played == gamemode_info.total_rounds:
			return [true, "all rounds played"]
	elif gamemode_info.key == "first_to":
		if state.player_score == gamemode_info.max_score or state.computer_score == gamemode_info.max_score:
			return [true, "max score was reached"]
	elif gamemode_info.key == "survival":
		if state.current_streak == 0 and state.rounds_played != 0:
			return [true, "streak lost"]
	elif gamemode_info.key == "comeback":
		if state.rounds_played == gamemode_info.total_rounds:
			return [true, "all rounds played"]
		else:
			if state.computer_score == gamemode_info.max_score:
				return [true, "AI got 7 points"]
	elif gamemode_info.key == "no_repeat":
		if state.rounds_played > 1 and state.player_move == state.player_history[-2]:
			return [true, "played the same move"]
			
	return [false, ""]
