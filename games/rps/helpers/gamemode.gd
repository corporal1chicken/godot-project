extends Node

# Each gamemode has a start() and a rules() function. instead of one giant
# if/elif statement

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
	if game_state.rounds_played == gamemode.total_rounds:
		return [true, "Max rounds played!"]
		
	return [false, ""]
	
func _survival_rules(game_state: Dictionary):
	if game_state.current_streak == 0 and game_state.rounds_played != 0:
		return [true, ("You lost your %d streak!" % [game_state.current_streak])]
	
	return [false, ""]
	
func _comeback_rules(game_state: Dictionary):
	if game_state.rounds_played == gamemode.total_rounds:
		return [true, "Max rounds played"]
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
		return [true, ("You played %s twice in a row!" % [game_state.player_move])]

	return [false, ""]

"""
var gamemode_info: Dictionary
var modifier_info

func _gamemode_edit(game_stats: Dictionary):
	if gamemode_info.get("starting_points"):
		game_stats.computer_score = gamemode_info.get("starting_points")
		
	if gamemode_info.get("points_on_win"):
		game_stats.points_on_win = gamemode_info.get("points_on_win")
	
	if gamemode_info.get("points_on_loss"):
		game_stats.points_on_loss = gamemode_info.get("points_on_loss")
	
	return game_stats
	
func _modifier_edit(game_stats: Dictionary):
	if modifier_info != null:
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

func set_game_info(gamemode: Dictionary, modifier):
	gamemode_info = gamemode
	modifier_info = modifier

func check_rules(state: Dictionary) -> Array:
	
	if gamemode_info.key == "best_of":
		if state.rounds_played == gamemode_info.total_rounds:
			return [true, "Max rounds played!"]
	elif gamemode_info.key == "first_to":
		if state.player_score == gamemode_info.max_score or state.computer_score == gamemode_info.max_score:
			return [true, ("%s reached %d points!" % ["You" if state.player_score > state.computer_score else "AI", gamemode_info.max_score])]
	elif gamemode_info.key == "survival":
		if state.current_streak == 0 and state.rounds_played != 0:
			return [true, ("You lost your %d streak!" % [state.current_streak])]
	elif gamemode_info.key == "comeback":
		if state.rounds_played == gamemode_info.total_rounds:
			return [true, "Max rounds played"]
		else:
			if state.computer_score == gamemode_info.max_score:
				return [true, "AI got 7 points"]
	elif gamemode_info.key == "no_repeat":
		if state.rounds_played > 1 and state.player_move == state.player_history[-2]:
			return [true, ("You played %s twice in a row!" % [state.player_move])]
			
	return [false, ""]
"""
