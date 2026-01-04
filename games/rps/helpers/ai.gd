extends Node

# Planning AI
# 1. Choose Random Move
# 2. Counter Last Move
# 3. Counter Most Common In The Last 7 Moves
# 4. Counter Random In The Last 5 Moves
# 5. Play The Same Move As Last
# 6. Play The Player's Last Move
# 7. Lose To Player's Move
# 8. Counter Player Move If Repeating More Than 3 Times

@export var test_mode: bool = false

const MOVES: Array = ["rock", "paper", "scissors"]

func get_computer_move(player_move) -> String:
	var move: String
	
	if test_mode:
		move = "paper"
	else:
		move = MOVES.pick_random()
	
	$"../ai_move".text = "AI picked " + move + " | your move: " + player_move
	
	return move
