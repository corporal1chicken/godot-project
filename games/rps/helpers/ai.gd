extends Node

const MOVES: Array = ["rock", "paper", "scissors"]

func get_computer_move() -> String:
	var move = MOVES.pick_random()
	$"../ai_move".text = "AI picked " + move
	
	return move
