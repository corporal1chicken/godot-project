extends Control

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
	losses = 0,
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
	max_rounds = -1,
	total_playtime = 0.0,
	override_timer_length = false,
	new_timer_length = 5.0,
	
	modifiers_active = []
}

var game_stats: Dictionary

var game_ended = false

var overlay_visible = false

# For Game Restart
var current_gamemode: Dictionary
var current_difficulty: Dictionary
var current_modifier

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
		
	$time_left.text = "Time Left: %.1f" % timer.time_left
	
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
		
		
		if $AnimationPlayer.is_playing(): return
		if overlay_visible:
			overlay_visible = false
			$AnimationPlayer.play_backwards("show_overlay")
		else:
			overlay_visible = true
			$AnimationPlayer.play("show_overlay")
		
	pass

# On Button Press Functions
func _on_move_pressed(move: String):
	game_stats.player_move = move
	
	if game_stats.modifiers_active.has("lock_input"):
		_toggle_moves_button(true)
	
func _on_continue_pressed():
	_main_loop()
	
func _on_quit_pressed():
	Signals.change_sub_screen.emit("main", "options")
	_end_game("", false)

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
	
func _update_round_text():
	$score_count.text = "You [%d]  |  AI [%d]" % [game_stats.player_score, game_stats.computer_score]
	$overlay/streak.text = "[%d] Streak\n[%d] Best" % [game_stats.current_streak, game_stats.best_streak]
	$overlay/rounds_played.text = "Round\n[%d/%s]" % [game_stats.rounds_played, (
		str(game_stats.max_rounds) if game_stats.max_rounds != -1 else "♾"
	)]
	
func _get_winner():
	if game_stats.player_move != "":
		game_stats.player_history.append(game_stats.player_move)
		
	if game_stats.modifiers_active.has("house_rules"):
		if game_stats.rounds_played > 0 and game_stats.rounds_played % 2 == 0:
			$round_end.text = "The House took their share! [-1 to you, -1 to AI]"
			game_stats.player_score -= 1
			game_stats.computer_score -= 1
			return
	
	if game_stats.player_move == "":
		$round_end.text = "You didn't pick a move. [-1 to you, +1 to AI]"
		game_stats.computer_score += game_stats.points_on_win
		game_stats.player_score -= game_stats.points_on_loss
	elif game_stats.player_move == game_stats.computer_move:
		game_stats.draws += 1

		if game_stats.modifiers_active.has("on_edge"):
			if randf() < 0.5:
				$round_end.text = "Draw, but the On Edge modifier is active! [-1 to you]"
				game_stats.player_score -= 1
			else:
				$round_end.text = "Draw, but you avoided the On Edge modifier this time!"
		elif game_stats.modifiers_active.has("thats_mean"):
			$round_end.text = "Draw, but That's Mean is active! Counted as a loss. [-2 to you]"
			game_stats.player_score -= 2
			game_stats.losses += 1
			_determine_streak("loss")
		else:
			$round_end.text = "Draw, no points awarded."
		
	elif RULES.get(game_stats.player_move) == game_stats.computer_move:
		if game_stats.modifiers_active.has("double_points"):
			$round_end.text = "You win, and you have Double Points active! [+2 points]"
		else:
			$round_end.text = "You win! [+1 points]"
		
		game_stats.player_score += game_stats.points_on_win
		_determine_streak("win")
	else:
		if game_stats.modifiers_active.has("fair_game"):
			if game_stats.rounds_played > 0 and game_stats.rounds_played % 3 == 0:
				$round_end.text = "You lost, but you have Fair Game active! [+%d, +1 additional to AI]" % [game_stats.points_on_loss]
				game_stats.computer_score += (game_stats.points_on_loss + 1)
				game_stats.losses += 1
				_determine_streak("loss")
		elif game_stats.modifiers_active.has("false_sense"):
			$round_end.text = "You lost, but you have False Sense active! Loss not counted."
			game_stats.modifiers_active.erase("false_sense")
		else:
			$round_end.text = "You lost! [+%d to AI]" % [game_stats.points_on_loss]
			game_stats.computer_score += game_stats.points_on_loss
			game_stats.losses += 1
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
	
	game_stats.player_move = ""
	$ai_move.text = "Rock, Paper or Scissors?"
	
	pass

func _end_round():
	game_stats.rounds_played += 1
	
	_get_winner()
	_toggle_moves_button(true)
	
	$continue.visible = true
	$round_end.visible = true
	
	$time_left.text = "Times up!"
	
	if game_stats.player_move != "":		
		game_stats.played_moves[game_stats.player_move] = game_stats.played_moves.get(game_stats.player_move) + 1
	
	if game_stats.modifiers_active.has("less_time"):
		if game_stats.timer_length != 1:		
			game_stats.timer_length -= 0.2
	
	_update_round_text()
	
	pass

# Game Functions
func restart_game():
	start_game(current_gamemode, current_difficulty, current_modifier)

func start_game(chosen_gamemode: Dictionary, chosen_difficulty: Dictionary, chosen_modifier):
	current_gamemode = chosen_gamemode
	current_difficulty = chosen_difficulty
	current_modifier = chosen_modifier
	
	game_stats = gamemode.setup_game(default_game_stats, chosen_gamemode, chosen_modifier, chosen_difficulty)

	_update_round_text()
	_main_loop()
	
	Signals.set_controls.emit(
		"controls:\n[1] Rock\n[2] Paper\n[3] Scissors\n[H] Overlay\n[Enter] Continue\n[Escape] Pause"
	)
	
	$overlay/currently_playing.text = "Difficulty: %s\nGamemode: %s\nModifier: %s" % [
		chosen_difficulty.get("text"),
		chosen_gamemode.get("text"),
		chosen_modifier.get("text") if chosen_modifier != null else "None"
	]
	
	pass
	
func _end_game(outcome_text: String, show_results: bool):
	_toggle_moves_button(true)
	
	game_ended = true
	
	if game_stats.modifiers_active.has("its_mine"):
		var old_player_score = game_stats.player_score
		game_stats.player_score = game_stats.computer_score
		game_stats.computer_score = old_player_score
		outcome_text = outcome_text + " and It's Mine Now was active!"
	
	if show_results:
		results.set_results_screen(game_stats, outcome_text)
		Signals.change_sub_screen.emit("main", "results")
		
	Signals.set_controls.emit("")
	pass
	
func _main_loop():
	_start_round()
	
	timer.start(game_stats.timer_length)
	await timer.timeout
		
	game_stats.computer_move = ai.get_computer_move(game_stats.player_move)
	
	_end_round()

	var should_end_game: Array = gamemode.check_rules(game_stats)
	
	if should_end_game[0]:
		_end_game(should_end_game[1], true)
	
	pass

# Signal Connections
func _on_game_paused():
	timer.paused = true

func _on_game_resumed():
	timer.paused = false
