extends Control

# Could have a retrieve_information so gamemode_info and difficulty_info
# are no longer needed here

@export var ai: Node
@export var results: Node
@export var gamemode: Node
@export var controls: String

@onready var timer: Timer = $Timer

const RULES: Dictionary = {
	"rock" = "scissors",
	"paper" = "rock",
	"scissors" = "paper"
}

var default_game_stats = {
	computer_move = "",
	computer_score = 0,
	
	player_move = "",
	player_score = 0,
	player_history = [],
	
	draws = 0,
	current_streak = 0,
	best_streak = 0,
	
	played_moves = {
		"rock" = 0,
		"paper" = 0,
		"scissors" = 0
	},
	
	points_on_win = 1,
	points_on_loss = 1,
	rounds_played = 0,
	total_playtime = 0.0
}

var game_stats: Dictionary

var gamemode_info: Dictionary
var difficulty_info: Dictionary
var modifier_info: Dictionary

var game_ended = false

# Godot Specific Functions
func _ready() -> void:
	Signals.game_paused.connect(_on_game_paused)
	Signals.game_resumed.connect(_on_game_resumed)
	
	for child in $moves.get_children():
		child.pressed.connect(_on_move_pressed.bind(child.name))
		
	randomize()
		
func _process(delta: float) -> void:
	if timer.is_stopped():
		return
		
	$time_left.text = "time left: %.1f" % timer.time_left
	
	if not game_ended:
		game_stats.total_playtime += delta
	
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
	elif event.is_action_pressed("rps_overlay"):
		$overlay.visible = not$overlay.visible
	
	pass

# On Button Press Functions
func _on_move_pressed(move: String):
	game_stats.player_move = move
	
	if game_stats.get("lock_input"):
		_toggle_moves_button(true)
	
	pass
	
func _on_continue_pressed():
	if not game_ended:
		_main_loop()
	else:
		Signals.change_sub_screen.emit("main", "options")
	
	pass

# Helper Functions
func _determine_streak(outcome: String):
	if outcome == "win":
		game_stats.current_streak += 1
		
		if game_stats.current_streak > game_stats.best_streak:
			game_stats.best_streak = game_stats.current_streak
	elif outcome == "loss":
		if game_stats.current_streak > game_stats.best_streak:
			game_stats.best_streak = game_stats.current_streak
			
		game_stats.current_streak = 0
		
	pass
	
func _update_round_text():
	$score_count.text = "player: %d | AI: %d" % [game_stats.player_score, game_stats.computer_score]
	$overlay/streak.text = "streak: %d\nbest: %d" % [game_stats.current_streak, game_stats.best_streak]
	$overlay/rounds_played.text = "round\n" + str(game_stats.rounds_played) + "/" + str(gamemode_info.get("total_rounds"))
	
	pass
	
func _get_winner():
	if game_stats.player_move == "":
		$round_end.text = "you didn't pick a move [-1 to you, +1 to AI]"
		game_stats.computer_score += game_stats.points_on_win
		game_stats.player_score -= game_stats.points_on_loss
	elif game_stats.player_move == game_stats.computer_move:
		game_stats.draws += 1
		
		# Not happy with referencing modifier_info here, will likely change
		# to a "check_rules" in gamemode.gd for both gamemode and modifiers
		if modifier_info.get("key") == "on_edge":
			if randf() < 0.5:
				$round_end.text = "Draw but you got On Edge Modifier! [-1 to you]"
				game_stats.player_score -= 1
			else:
				$round_end.text = "Draw but you avoided the On Edge Modifier this time!"
		else:
			$round_end.text = "Draw, no points awarded."
		
	elif RULES.get(game_stats.player_move) == game_stats.computer_move:
		$round_end.text = "you win! " + game_stats.player_move + " beats " + game_stats.computer_move + ". [+1 to you]"
		game_stats.player_score += game_stats.points_on_win
		_determine_streak("win")
	else:
		$round_end.text = "you lose! " + game_stats.computer_move + " beats " + game_stats.player_move + ". [+1 to AI]"
		game_stats.computer_score += game_stats.points_on_loss
		_determine_streak("loss")
	
	if game_stats.player_move != "":
		game_stats.player_history.append(game_stats.player_move)

	pass
	
func _toggle_moves_button(new_state: bool):
	for child in $moves.get_children():
		child.disabled = new_state

# Individual Round Functions
func _start_round():
	$round_end.visible = false
	$continue.visible = false
	
	_toggle_moves_button(false)
	
	game_stats.player_move = ""
	$ai_move.text = "pick a move"
	
	pass

func _end_round():
	_get_winner()
	_toggle_moves_button(true)
	
	$continue.visible = true
	$round_end.visible = true
	
	game_stats.rounds_played += 1
	
	if game_stats.player_move != "":		
		game_stats.played_moves[game_stats.player_move] = game_stats.played_moves.get(game_stats.player_move) + 1
	
	_update_round_text()
	
	pass
	
func start_game(chosen_gamemode: Dictionary, chosen_difficulty: Dictionary, chosen_modifier: Dictionary):
	gamemode_info = chosen_gamemode
	difficulty_info = chosen_difficulty
	modifier_info = chosen_modifier
	
	gamemode.set_game_info(chosen_gamemode, chosen_modifier)
	game_stats = gamemode.edit_game_stats(default_game_stats)
	
	_update_round_text()
	_main_loop()
	
	Signals.set_controls.emit(
		"controls:\n[1] Rock\n[2] Paper\n[3] Scissors\n[H] Overlay\n[Enter] Continue\n[Escape] Pause"
	)
	
	pass
	
func _end_game(outcome_text: String):
	_toggle_moves_button(true)
	
	game_ended = true
	
	#results.set_results_screen(game_stats)
	
	Signals.change_sub_screen.emit("main", "results")
	Signals.set_controls.emit("")
	pass
	
func _main_loop():
	_start_round()
	
	timer.start(difficulty_info.timer_length)
	await timer.timeout
	
	game_stats.computer_move = ai.get_computer_move(game_stats.player_move)
	
	_end_round()

	var should_end_game: Array = gamemode.check_rules(game_stats)
	
	if should_end_game[0]:
		_end_game(should_end_game[1])
	
	pass

# Signal Connections
func _on_game_paused():
	timer.paused = true

func _on_game_resumed():
	timer.paused = false
