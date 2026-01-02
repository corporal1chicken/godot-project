extends Control

# Future Ideas:
# - AI changes based on difficulty
# - Custom First To and Best Of parameters

# Needed:
# - Reset game function
# - When the game ends, going back to the selection screen
# - Likely a determine game winner function

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

var games_played: int = 0

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
	
	games_played += 1
	
	$score_count.text = "player: " + str(player_score) + " | computer: " + str(computer_score)

func _get_computer_move() -> String:
	return RULES.keys().pick_random()

func _get_winner():
	if player_move == "":
		$round_text.text = "you didn't pick a move."
		computer_score += 1
	else:
		var computer_move = _get_computer_move()
		$ai_move.text = "AI move: " + computer_move + " | your move: " + player_move
		
		if player_move == computer_move:
			$round_text.text = "it's a draw"
			draws += 1
		elif computer_move in RULES.get(player_move):
			$round_text.text = "you win! " + player_move + " beats " + computer_move
			player_score += 1
		else:
			$round_text.text = "you lose! " + computer_move + " beats " + player_move
			computer_score += 1

func start_game(new_difficulty_info: Dictionary, gamemode: String):
	difficulty_info = new_difficulty_info
	current_gamemode = gamemode
	
	_set_new_round()
	
	timer.start(difficulty_info.timer_length)
	await timer.timeout
	
	_end_current_round()
	
	if gamemode == "best_of":
		if games_played == 5:
			_end_game()
			return
	elif gamemode == "first_to":
		if player_score == 3 or computer_score == 3:
			_end_game()
			return
		
func _end_game():
	_toggle_button_state(true)
	$time_left.text = "game ended"
	$ai_move.visible = false
	$round_text.visible = true
	
func _on_continue_pressed():
	start_game(difficulty_info, current_gamemode)
	pass
