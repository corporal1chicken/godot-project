extends Control

# Future Ideas:
# - AI changes based on difficulty
# - Custom First To and Best Of parameters
# - Quit game button

# Needed:
# - Reset game function
# - Update text function
# - Determine game winner function
# - Determine streak function

# Could seperate AI, game and gamemode logic
# All scripts attached to the main screen instead of each sub screen

@onready var time_left: RichTextLabel = $time_left
@onready var timer: Timer = $Timer

const RULES: Dictionary = {
	"rock" = "scissors",
	"paper" = "rock",
	"scissors" = "paper"
}

var player_move: String = ""
var difficulty_info: Dictionary
var current_gamemode: String

var player_score: int = 0
var computer_score: int = 0
var draws: int = 0

var rounds_played: int = 0
var current_streak: int = 0
var best_streak: int = 0

var game_ended = false

func _ready() -> void:
	for child in $moves.get_children():
		child.pressed.connect(_on_move_pressed.bind(child.name))

func _process(_delta: float) -> void:
	if timer.is_stopped():
		return
		
	time_left.text = "time left: %.1f" % timer.time_left
	
func _toggle_button_state(new_state: bool):
	for child in $moves.get_children():
		child.disabled = new_state
	
func _on_move_pressed(move: String):
	player_move = move
	
func _set_new_round():
	$round_text.visible = false
	
	_toggle_button_state(false)
	$continue.visible = false
	player_move = ""
	$ai_move.text = "pick a move"
	
func _end_current_round():
	_get_winner()
	_toggle_button_state(true)
	$continue.visible = true
	$round_text.visible = true
	
	rounds_played += 1
	
	$score_count.text = "player: " + str(player_score) + " | computer: " + str(computer_score)
	$streak.text = "streak: %d\nbest: %d" % [current_streak, best_streak]

func _get_computer_move() -> String:
	return RULES.keys().pick_random()

func _get_winner():
	if player_move == "":
		$round_text.text = "you didn't pick a move."
		computer_score += 1
		
		if current_streak > best_streak:
			best_streak = current_streak
		
		current_streak = 0
	else:
		var computer_move = _get_computer_move()
		$ai_move.text = "AI move: " + computer_move + " | your move: " + player_move
		
		if player_move == computer_move:
			$round_text.text = "it's a draw"
			draws += 1
		elif computer_move in RULES.get(player_move):
			$round_text.text = "you win! " + player_move + " beats " + computer_move
			player_score += 1
			current_streak += 1
			
			if current_streak > best_streak:
				best_streak = current_streak
		else:
			$round_text.text = "you lose! " + computer_move + " beats " + player_move
			computer_score += 1
			
			if current_streak != 0 and current_streak > best_streak:
				best_streak = current_streak
			
			current_streak = 0

func _continue_game():	
	_set_new_round()
	
	timer.start(difficulty_info.timer_length)
	await timer.timeout
	
	_end_current_round()
	
	if current_gamemode == "best_of":
		if rounds_played == 5:
			_end_game()
			return
	elif current_gamemode == "first_to":
		if player_score == 3 or computer_score == 3:
			_end_game()
			return
	elif current_gamemode == "survival":
		if current_streak == 0 and rounds_played != 0:
			_end_game()
			return
			
func begin_game(new_difficulty_info: Dictionary, gamemode: String):
	difficulty_info = new_difficulty_info
	current_gamemode = gamemode
	
	game_ended = false
	rounds_played = 0
	player_score = 0
	computer_score = 0
	draws = 0
	
	current_streak = 0
	best_streak = current_streak
	
	$score_count.text = "player: " + str(player_score) + " | computer: " + str(computer_score)
	$streak.text = "streak: %d\nbest: %d" % [current_streak, best_streak]
	$ai_move.visible = true
	
	_continue_game()
		
func _end_game():
	_toggle_button_state(true)
	$time_left.text = "game ended"
	$ai_move.visible = false
	$round_text.visible = true
	
	game_ended = true
	
func _on_continue_pressed():
	if not game_ended:
		_continue_game()
	else:
		Signals.change_sub_screen.emit("main", "options")

func _on_quit_pressed():
	Signals.change_sub_screen.emit("main", "options")
