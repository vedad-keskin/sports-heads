extends Node2D

const PlayerBody = preload("res://scripts/match/player_body.gd")
const GameBall = preload("res://scripts/match/game_ball.gd")
const PowerUpManager = preload("res://scripts/match/power_up_manager.gd")
const AiOpponent = preload("res://scripts/match/ai_opponent.gd")
const LeagueManager = preload("res://scripts/league/league_manager.gd")

signal match_finished(hero_score: int, opp_score: int)

@onready var hud: Control = $HUD

var hero: PlayerBody
var opp: PlayerBody
var ball: GameBall
var pu_manager: PowerUpManager
var ai: AiOpponent

var hero_score: int = 0
var opp_score: int = 0
var time_left: float = GameConstants.MATCH_TIME_SECONDS
var paused: bool = false
var playing: bool = false
var countdown: float = 3.0
var oppxspeed: float = 0.0
var win_margin: int = 999
var ai_level: float = 5.0

var _goal_left: Area2D
var _goal_right: Area2D
var _banner_timer: float = 0.0
var _banner_text: String = ""

func _ready() -> void:
	_build_arena()
	_spawn_entities()
	pu_manager = PowerUpManager.new()
	add_child(pu_manager)
	pu_manager.setup(self, ball, hero, opp)
	pu_manager.banner_text.connect(_on_pu_banner)
	ai = AiOpponent.new()
	_configure_match_mode()
	_update_hud()

func _configure_match_mode() -> void:
	_apply_pitch_theme()
	if GameState.two_player_mode:
		match GameState.tp_game_type:
			GameState.GameType.TIMED:
				time_left = GameConstants.MATCH_TIME_SECONDS
				win_margin = 999
			GameState.GameType.FIRST_TO_SEVEN:
				time_left = 9999.0
				win_margin = GameConstants.WIN_MARGIN_FIRST_TO_SEVEN
			GameState.GameType.GOLDEN_GUN:
				time_left = 9999.0
				win_margin = 1
	else:
		time_left = GameConstants.MATCH_TIME_SECONDS
		win_margin = 999
		for t in GameState.team_list:
			if t[9] == GameState.next_opponent_id:
				ai_level = float(t[1])
				break
		if GameState.round_num > 11:
			ai_level += 3.0
		if GameState.round_num > 22:
			ai_level += 4.0
		ai.ai_level = ai_level

func _apply_pitch_theme() -> void:
	var pitch_id := GameState.tp_pitch if GameState.two_player_mode else GameState.face_num
	var hue := fmod(float(pitch_id) * 0.07, 1.0)
	if get_child_count() > 0 and get_child(0) is ColorRect:
		get_child(0).color = Color.from_hsv(hue, 0.55, 0.35)

func _build_arena() -> void:
	# Pitch background
	var bg := ColorRect.new()
	bg.color = Color(0.12, 0.45, 0.18)
	bg.position = Vector2.ZERO
	bg.size = GameConstants.VIEWPORT_SIZE
	bg.z_index = -10
	add_child(bg)
	_add_wall(Vector2(-5, 240), Vector2(20, 480))
	_add_wall(Vector2(805, 240), Vector2(20, 480))
	_add_wall(Vector2(400, -5), Vector2(800, 20))
	_add_wall(Vector2(400, 470), Vector2(800, 20))
	# Goals
	_goal_left = _add_goal(Vector2(40, 360), Vector2(80, 100), true)
	_goal_right = _add_goal(Vector2(760, 360), Vector2(80, 100), false)

func _add_wall(center: Vector2, size: Vector2) -> void:
	var body := StaticBody2D.new()
	body.position = center
	var col := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = size
	col.shape = rect
	body.add_child(col)
	add_child(body)

func _add_goal(center: Vector2, size: Vector2, is_left: bool) -> Area2D:
	var area := Area2D.new()
	area.position = center
	area.set_meta("is_left", is_left)
	var col := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = size
	col.shape = rect
	area.add_child(col)
	area.body_entered.connect(_on_goal_body.bind(is_left))
	add_child(area)
	return area

func _spawn_entities() -> void:
	hero = PlayerBody.new()
	hero.side = PlayerBody.Side.HERO
	hero.head_color = Color(0.9, 0.75, 0.2)
	hero.position = GameConstants.HERO_SPAWN
	add_child(hero)

	opp = PlayerBody.new()
	opp.side = PlayerBody.Side.OPP
	opp.head_color = Color(0.3, 0.5, 0.95)
	opp.position = GameConstants.OPP_SPAWN
	add_child(opp)

	ball = GameBall.new()
	ball.position = GameConstants.BALL_SPAWN
	ball.linear_velocity = Vector2(randf_range(-150, 150), -100)
	add_child(ball)
	ball.touched.connect(func(side): pass)

func _physics_process(delta: float) -> void:
	if not playing:
		countdown -= delta
		if countdown <= 0.0:
			playing = true
			AudioManager.play_sfx("whistle")
		_update_hud()
		return
	if paused:
		return

	if not GameState.two_player_mode:
		oppxspeed = ai.update(delta, opp, ball, oppxspeed)
	else:
		_process_p2_input(delta)

	_process_p1_input(delta)
	pu_manager.physics_update(delta)
	_update_ball_touch()

	if time_left < 9000.0:
		time_left -= delta
		if time_left <= 0.0:
			_end_match()

	_check_goals()
	if hero_score >= win_margin or opp_score >= win_margin:
		_end_match()

	if _banner_timer > 0.0:
		_banner_timer -= delta

	_update_hud()

func _process_p1_input(delta: float) -> void:
	var upg: Array = GameState.upgrade_list[0] if GameState.upgrade_list.size() > 0 else []
	var kick := Input.is_key_pressed(KEY_P) if GameState.two_player_mode else Input.is_key_pressed(KEY_SPACE)
	if Input.is_key_pressed(KEY_B) and not GameState.upgrade_lock:
		if upg.size() > 4 and int(upg[4]) > 0:
			upg[4] = int(upg[4]) - 1
			GameState.upgrade_lock = true
			hero.set_head_scale(1.5)
			pu_manager.hero_effects["size"] = GameConstants.PU_DURATION_BOMBS
	elif not Input.is_key_pressed(KEY_B):
		GameState.upgrade_lock = false
	hero.apply_movement_input(
		Input.is_action_pressed("p1_left"),
		Input.is_action_pressed("p1_right"),
		Input.is_action_pressed("p1_up"),
		kick,
		upg, delta
	)

func _process_p2_input(delta: float) -> void:
	opp.apply_movement_input(
		Input.is_action_pressed("p2_left"),
		Input.is_action_pressed("p2_right"),
		Input.is_action_pressed("p2_up"),
		Input.is_action_pressed("p2_kick"),
		[0, 0, 0, 0], delta
	)

func _check_goals() -> void:
	if ball.global_position.x < 55 and abs(ball.global_position.y - 360) < 80:
		_score_goal(false)
	elif ball.global_position.x > 745 and abs(ball.global_position.y - 360) < 80:
		_score_goal(true)

func _score_goal(hero_scored: bool) -> void:
	if hero_scored:
		hero_score += 1
	else:
		opp_score += 1
	AudioManager.play_sfx("cheer")
	_reset_positions()
	if GameState.two_player_mode and win_margin <= 7:
		pass

func _reset_positions() -> void:
	ball.global_position = GameConstants.BALL_SPAWN
	ball.linear_velocity = Vector2(randf_range(-100, 100), -80)
	hero.global_position = GameConstants.HERO_SPAWN
	hero.linear_velocity = Vector2.ZERO
	opp.global_position = GameConstants.OPP_SPAWN
	opp.linear_velocity = Vector2.ZERO
	playing = false
	countdown = 2.0

func _end_match() -> void:
	playing = false
	set_physics_process(false)
	var won := hero_score > opp_score
	GameState.last_hero_score = hero_score
	GameState.last_opp_score = opp_score
	GameState.last_match_won = won
	if GameState.two_player_mode and won:
		AchievementManager.award(7)
	if not GameState.two_player_mode:
		var player_id := GameState.team_list[GameState.face_num - 1][9]
		LeagueManager.simulate_round(GameState.round_num, player_id, hero_score, opp_score, GameState.next_opponent_id)
		if won:
			GameState.upgrade_points += GameConstants.WIN_UPGRADE_POINTS
		else:
			GameState.upgrade_points += GameConstants.LOSS_UPGRADE_POINTS
		GameState.round_num += 1
		SaveManager.save_game()
	match_finished.emit(hero_score, opp_score)
	call_deferred("_goto_results")

func _update_ball_touch() -> void:
	if ball.global_position.distance_to(hero.global_position) < 35.0:
		ball.notify_touch("hero")
	elif ball.global_position.distance_to(opp.global_position) < 35.0:
		ball.notify_touch("opp")
	if ball.linear_velocity.length() > 200:
		pass

func _goto_results() -> void:
	var main := get_tree().root.get_node_or_null("Main")
	if main and main.has_method("go_to"):
		main.go_to(GameState.Screen.MATCH_RESULTS)

func _on_goal_body(body: Node, is_left: bool) -> void:
	if body == ball:
		_score_goal(not is_left)

func _on_pu_banner(text: String) -> void:
	_banner_text = text
	_banner_timer = 2.0

func _update_hud() -> void:
	if hud and hud.has_method("refresh"):
		hud.refresh(hero_score, opp_score, time_left, countdown, playing, _banner_text, _banner_timer)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") and playing:
		paused = not paused
