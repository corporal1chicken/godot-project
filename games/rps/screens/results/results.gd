extends Control

func _on_return_pressed():
	Signals.change_sub_screen.emit("results", "options")

func set_results_screen(information: Dictionary):
	$game_length.text = "game length: %02d:%02d" % [information.playtime / 60, information.playtime % 60]
	$score.text = ("score: [%d] player | [%d] AI | [%d] draws" % [
		information.player_score,
		information.computer_score,
		information.draws
	])
	$rounds_played.text = "rounds played: %d" % [information.rounds_played]
	$streak.text = "streak: %d (best: %d)" % [information.streak, information.best_streak]
	$played_moves.text = "played moves: rock (%d) | paper (%d) | scissors (%d)" % [
		information.played_moves.rock,
		information.played_moves.paper,
		information.played_moves.scissors
	]
	$outcome_text.text = information.outcome_text
	pass
