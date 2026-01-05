extends Control

# Could have a retrieve_information so gamemode_info and difficulty_info
# are no longer needed here

@export var ai: Node
@export var results: Node
@export var gamemode: Node

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

var player_history: Array = []

var player_score: int = 0
var computer_score: int = 0
var draws: int = 0
var rounds_played: int = 0
var current_streak: int = 0
var best_streak: int = 0

var played_moves: Dictionary = {
	"rock" = 0,
	"paper" = 0,
	"scissors" = 0
}

var total_playtime: float = 0.0

var game_ended = false

# Godot Specific Functions
func _ready() -> void:
	Signals.game_paused.connect(_on_game_paused)
	Signals.game_resumed.connect(_on_game_resumed)
	
	for child in $moves.get_children():
		child.pressed.connect(_on_move_pressed.bind(child.name))
		
func _process(delta: float) -> void:
	if timer.is_stopped():
		return
		
	$time_left.text = "time left: %.1f" % timer.time_left
	
	if not game_ended:
		total_playtime += delta
	
	pass
	
func _unhandled_input(event: InputEvent) -> void:
	if game_ended:
		return
		
	if event.is_action_pressed("rps_rock"):
		if $moves.get_child(0).disabled: return
		_on_move_pressed("rock")
		$moves/rock.grab_focus()
	elif event.is_action_pressed("rps_paper"):
		if $moves.get_child(0).disabled: return
		_on_move_pressed("paper")
		$moves/paper.grab_focus()
	elif event.is_action_pressed("rps_scissors"):
		if $moves.get_child(0).disabled: return
		_on_move_pressed("scissors")
		$moves/scissors.grab_focus()
	elif event.is_action_pressed("continue"):
		if $continue.visible == false:
			return
			
		_on_continue_pressed()
		$continue.grab_focus()
	
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
	$score_count.text = "player: %d | AI: %d" % [player_score, computer_score]
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
	
	if player_move != "":
		player_history.append(player_move)

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
	
	if player_move != "":		
		played_moves[player_move] = played_moves.get(player_move) + 1
	
	_update_round_text()
	
	pass

# Game Loop Functions
func _reset_game():
	game_ended = false
	rounds_played = 0
	player_score = 0
	draws = 0
	current_streak = 0
	best_streak = 0
	computer_score = 0
	player_history = []
	
	# Hardcoded for now
	if gamemode_info.name == "comeback":
		computer_score += 3
	
	pass
	
func start_game(chosen_gamemode: Dictionary, chosen_difficulty: Dictionary):
	gamemode_info = chosen_gamemode
	difficulty_info = chosen_difficulty
	
	gamemode.set_gamemode_info(chosen_gamemode)
	
	_reset_game()
	_update_round_text()
	_main_loop()
	
	pass
	
func _end_game(outcome_text: String):
	_toggle_moves_button(true)
	
	game_ended = true
	
	results.set_results_screen({
		"playtime" = int(total_playtime),
		"player_score" = player_score,
		"computer_score" = computer_score,
		"draws" = draws,
		"rounds_played" = rounds_played,
		"streak" = current_streak,
		"best_streak" = best_streak,
		"played_moves" = played_moves,
		"outcome_text" = outcome_text
	})
	
	Signals.change_sub_screen.emit("main", "results")
	pass
	
func _main_loop():
	_start_round()
	
	timer.start(difficulty_info.timer_length)
	await timer.timeout
	
	computer_move = ai.get_computer_move(player_move)
	
	_end_round()
	
	var state = {
		"rounds_played" = rounds_played,
		"player_score" = player_score,
		"computer_score" = computer_score,
		"current_streak" = current_streak,
		"player_history" = player_history,
		"player_move" = player_move
	}
	
	var should_end_game: Array = gamemode.check_rules(state)
	
	if should_end_game[0]:
		_end_game(should_end_game[1])
	
	pass

# Signal Connections
func _on_game_paused():
	timer.paused = true

func _on_game_resumed():
	timer.paused = false
