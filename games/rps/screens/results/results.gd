extends Control

func _on_return_pressed():
	Signals.change_sub_screen.emit("results", "options")

func set_results_screen(information: Dictionary, outcome_text: String):
	$game_length.text = " [Game Length]: 	%02d:%02d" % [int(information.total_playtime) / 60, int(information.total_playtime) % 60]
	$score.text = (" [Score]: 			Player (%d) | AI (%d)" % [
		information.player_score,
		information.computer_score,
	])
	$rounds_played.text = " [Rounds Played]: 	%d" % [information.rounds_played]
	$streak.text = " [Streak]:			%d (Best: %d)" % [information.current_streak, information.best_streak]
	$played_moves.text = " [Played Moves]:			  Rock (%d) | Paper (%d) | Scissors (%d)" % [
		information.played_moves.rock,
		information.played_moves.paper,
		information.played_moves.scissors
	]
	$outcome_text.text = outcome_text
	pass
