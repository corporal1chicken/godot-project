extends Node

@export var test_mode: bool = false

const MOVES: Array = ["rock", "paper", "scissors"]

func get_computer_move(player_move) -> String:
	var move: String
	
	if test_mode:
		move = "paper"
	else:
		move = MOVES.pick_random()
	
	$"../ai_move".text = "AI picked %s against your %s" % [move, player_move]
	
	return move
