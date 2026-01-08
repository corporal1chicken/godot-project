extends Node

var rules: Dictionary = {
	"best_of" = _best_of_rules,
	"survival" = _survival_rules,
	"comeback" = _comeback_rules,
	"first_to" = _first_to_rules,
	"no_repeat" = _no_repeat_rules
}

var gamemode: Dictionary
var modifier

func _gamemode_edit(game_stats: Dictionary):
	for key in game_stats.keys():
		if gamemode.get(key):
			game_stats[key] = gamemode.get(key)
			
	return game_stats
	
func _modifier_edit(game_stats: Dictionary):
	if modifier != null:
		var key = modifier.get("key")

		game_stats["modifiers_active"].append(key)
		
		if key == "double_points":
			game_stats.points_on_win *= 2
		elif key == "less_time":
			game_stats.timer_length = 5
		elif key == "unfair_start":
			game_stats.player_score = -4
	
	return game_stats

func setup_game(default_game_stats, chosen_gamemode, chosen_modifier, chosen_difficulty) -> Dictionary:
	var new_game_stats = default_game_stats.duplicate(true)

	gamemode = chosen_gamemode
	modifier = chosen_modifier
	
	new_game_stats.timer_length = chosen_difficulty.timer_length
	
	var gamemode_edit_stats = _gamemode_edit(new_game_stats)
	var final_edit_stats = _modifier_edit(gamemode_edit_stats)
	
	return final_edit_stats
	
func check_rules(game_state: Dictionary) -> Array:
	var key = gamemode.get("key")
	
	if rules.has(key):
		return rules[key].call(game_state)

	return [false, ""]

func _best_of_rules(game_state: Dictionary):
	if game_state.rounds_played == gamemode.max_rounds:
		return [true, "All rounds played!"]
		
	return [false, ""]
	
func _survival_rules(game_state: Dictionary):
	if game_state.current_streak == 0 and game_state.rounds_played != 0:
		return [true, ("You lost your %d streak!" % [game_state.best_streak])]
	
	return [false, ""]
	
func _comeback_rules(game_state: Dictionary):
	if game_state.rounds_played == gamemode.max_rounds:
		return [true, "All rounds played"]
	else:
		if game_state.computer_score == gamemode.max_score:
			return [true, "AI got 7 points"]
			
	return [false, ""]
	
func _first_to_rules(game_state: Dictionary):
	if game_state.player_score == gamemode.max_score or game_state.computer_score == gamemode.max_score:
		return [true, ("%s reached %d points!" % ["You" if game_state.player_score > game_state.computer_score else "AI", gamemode.max_score])]
	
	return [false, ""]
	
func _no_repeat_rules(game_state: Dictionary):
	if game_state.rounds_played > 1 and game_state.player_move == game_state.player_history[-2]:
		return [true, ("You played %s twice in a row!" % [game_state.player_move.capitalize()])]

	return [false, ""]
