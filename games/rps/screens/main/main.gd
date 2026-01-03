extends Control

# Future Ideas:
# - AI changes based on difficulty
# - Custom First To and Best Of parameters

@export var ai: Node

@onready var timer: Timer = $Timer

const RULES: Dictionary = {
	"rock" = "scissors",
	"paper" = "rock",
	"scissors" = "paper"
}

var gamemode_info: Dictionary
var difficulty_info: Dictionary

var player_move: String = ""
var computer_move: String

var player_score: int = 0
var computer_score: int = 0
var draws: int = 0
var rounds_played: int = 0
var current_streak: int = 0
var best_streak: int = 0

var game_ended = false

# Godot Specific Functions
func _ready() -> void:
	for child in $moves.get_children():
		child.pressed.connect(_on_move_pressed.bind(child.name))
		
func _process(_delta: float) -> void:
	if timer.is_stopped():
		return
		
	$time_left.text = "time left: %.1f" % timer.time_left
	
	pass
	
func _unhandled_input(event: InputEvent) -> void:
	if game_ended or $moves.get_child(0).disabled:
		return
		
	if event.is_action_pressed("rps_rock"):
		_on_move_pressed("rock")
		$moves/rock.grab_focus()
	elif event.is_action_pressed("rps_paper"):
		_on_move_pressed("paper")
		$moves/paper.grab_focus()
	elif event.is_action_pressed("rps_scissors"):
		_on_move_pressed("scissors")
		$moves/scissors.grab_focus()
	
	pass

# On Button Press Functions
func _on_move_pressed(move: String):
	player_move = move
	
	pass
	
func _on_continue_pressed():
	if not game_ended:
		_main_loop()
	else:
		Signals.change_sub_screen.emit("main", "options")
	
	pass
	
func _on_quit_pressed():
	Signals.change_sub_screen.emit("main", "options")
	
	pass

# Helper Functions
func _check_gamemode_rules() -> bool:
	if gamemode_info.name == "best_of":
		if rounds_played == gamemode_info.total_rounds:
			return true
	elif gamemode_info.name == "first_to":
		if player_score == gamemode_info.max_score or computer_score == gamemode_info.max_score:
			return true
	elif gamemode_info.name == "survival":
		if current_streak == 0 and rounds_played > 0:
			return true
			
	return false
	
func _determine_streak(outcome: String):
	if outcome == "win":
		current_streak += 1
		
		if current_streak > best_streak:
			best_streak = current_streak
	elif outcome == "loss":
		if current_streak > best_streak:
			best_streak = current_streak
			
		current_streak = 0
		
	pass
	
func _update_round_text():
	$score_count.text = "player: " + str(player_score) + " | computer: " + str(computer_score)
	$streak.text = "streak: %d\nbest: %d" % [current_streak, best_streak]
	$rounds_played.text = "round\n" + str(rounds_played) + "/" + str(gamemode_info.get("total_rounds"))
	
	pass
	
func _get_winner():
	if player_move == "":
		$round_end.text = "you didn't pick a move [-1 to you, +1 to AI]"
		computer_score += 1
		player_score -= 1
	elif player_move == computer_move:
		$round_end.text = "it's a draw"
		draws += 1
	elif RULES.get(player_move) == computer_move:
		$round_end.text = "you win! " + player_move + " beats " + computer_move + ". [+1 to you]"
		player_score += 1
		_determine_streak("win")
	else:
		$round_end.text = "you lose! " + computer_move + " beats " + player_move + ". [+1 to AI]"
		computer_score += 1
		_determine_streak("loss")
	
	pass
	
func _toggle_moves_button(new_state: bool):
	for child in $moves.get_children():
		child.disabled = new_state

# Individual Round Functions
func _start_round():
	$round_end.visible = false
	$continue.visible = false
	
	_toggle_moves_button(false)
	
	player_move = ""
	$ai_move.text = "pick a move"
	
	pass

func _end_round():
	_get_winner()
	_toggle_moves_button(true)
	
	$continue.visible = true
	$round_end.visible = true
	
	rounds_played += 1
	
	_update_round_text()
	
	pass

# Game Loop Functions
func _reset_game():
	game_ended = false
	rounds_played = 0
	player_score = 0
	computer_score = 0
	draws = 0
	current_streak = 0
	best_streak = 0
	
	pass
	
func start_game(chosen_gamemode: Dictionary, chosen_difficulty: Dictionary):
	gamemode_info = chosen_gamemode
	difficulty_info = chosen_difficulty
	
	_reset_game()
	_update_round_text()
	_main_loop()
	
	pass
	
func _end_game():
	_toggle_moves_button(true)
	$time_left.text = "game ended"
	$ai_move.visible = false
	$round_end.visible = true
	
	game_ended = true
	
	if computer_score > player_score:
		$round_end.text = "AI won with " + str(computer_score) + " by " + str(computer_score - player_score) + " points"
	elif player_score > computer_score:
		$round_end.text = "you won with " + str(player_score) + " by " + str(player_score - computer_score) + " points"
	else:
		$round_end.text = "it was a draw"
	
	pass
	
func _main_loop():
	_start_round()
	
	timer.start(difficulty_info.timer_length)
	await timer.timeout
	
	computer_move = ai.get_computer_move()
	
	_end_round()
	
	if _check_gamemode_rules():
		_end_game()
	
	pass
