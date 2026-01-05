extends Node

# Could likely set a current_gamemode with a match function
# Could create gamemode start and end functions
# i.e. comeback_start() that sets AI points to 3

var gamemode_info: Dictionary

func set_gamemode_info(information: Dictionary):
	gamemode_info = information

func check_rules(state: Dictionary) -> Array:
	
	if gamemode_info.name == "best_of":
		if state.rounds_played == gamemode_info.total_rounds:
			return [true, "all rounds played"]
	elif gamemode_info.name == "first_to":
		if state.player_score == gamemode_info.max_score or state.computer_score == gamemode_info.max_score:
			return [true, "max score was reached"]
	elif gamemode_info.name == "survival":
		if state.current_streak == 0 and state.rounds_played != 0:
			return [true, "streak lost"]
	elif gamemode_info.name == "comeback":
		if state.rounds_played == gamemode_info.total_rounds:
			return [true, "all rounds played"]
		else:
			if state.computer_score == gamemode_info.max_score:
				return [true, "AI got 7 points"]
	elif gamemode_info.name == "no_repeat":
		if state.rounds_played > 1 and state.player_move == state.player_history[-2]:
			return [true, "played the same move"]
			
	return [false, ""]
