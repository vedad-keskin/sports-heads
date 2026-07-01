extends Node
class_name PowerUpManager

const DataLoader = preload("res://scripts/util/data_loader.gd")
const GameBall = preload("res://scripts/match/game_ball.gd")
const PlayerBody = preload("res://scripts/match/player_body.gd")

signal banner_text(text: String)

var _spawn_timer: float = 0.0
var _active_pickups: Array = []
var _pu_defs: Array = []

# Timed effects (seconds remaining, -1 = inactive)
var hero_effects := _blank_effects()
var opp_effects := _blank_effects()
var neutral := {"fire": 0.0, "size": 1.0, "bouncy": 1.0, "streaker": 0.0}

var _match: Node2D
var _ball: GameBall
var _hero: PlayerBody
var _opp: PlayerBody

static func _blank_effects() -> Dictionary:
	return {
		"speed": -1.0, "jump": -1.0, "ice": -1.0, "bombs": -1.0,
		"size": -1.0, "break": -1.0,
		"speed_val": 1.0, "jump_val": 1.0,
	}

func setup(match: Node2D, ball: GameBall, hero: PlayerBody, opp: PlayerBody) -> void:
	_match = match
	_ball = ball
	_hero = hero
	_opp = opp
	_pu_defs = DataLoader.load_json("res://data/powerups.json")

func physics_update(delta: float) -> void:
	_spawn_timer += delta
	if _spawn_timer >= GameConstants.PU_SPAWN_INTERVAL:
		_spawn_timer = 0.0
		_spawn_random_pu()
	_tick_effects(delta, hero_effects, _hero)
	_tick_effects(delta, opp_effects, _opp)
	_tick_neutral(delta)
	_update_pickups(delta)
	_check_collection()

func _tick_effects(delta: float, fx: Dictionary, body: PlayerBody) -> void:
	for key in ["speed", "jump", "ice", "bombs", "size", "break"]:
		if fx[key] > 0.0:
			fx[key] -= delta
			if fx[key] <= 0.0:
				fx[key] = -1.0
				_clear_effect(key, body, fx)
	body.frozen = fx["ice"] > 0.0
	body.pu_speed = fx["speed_val"]
	body.pu_jump = fx["jump_val"]
	body.leg_broken = fx["break"] > 0.0

func _clear_effect(key: String, body: PlayerBody, fx: Dictionary) -> void:
	match key:
		"speed":
			fx["speed_val"] = 1.0
			body.pu_speed = 1.0
		"jump":
			fx["jump_val"] = 1.0
			body.pu_jump = 1.0
		"ice":
			body.frozen = false
		"size":
			body.set_head_scale(1.0)

func _tick_neutral(delta: float) -> void:
	if neutral["fire"] > 0.0:
		neutral["fire"] -= delta

func _spawn_random_pu() -> void:
	if _pu_defs.is_empty():
		return
	var def: Dictionary = _pu_defs[randi() % _pu_defs.size()]
	var node := Node2D.new()
	node.set_meta("pu_id", def["id"])
	node.set_meta("lifetime", GameConstants.PU_FIELD_LIFETIME)
	node.position = Vector2(randf_range(220, 580), randf_range(150, 420))
	var vis := Polygon2D.new()
	vis.color = Color(def.get("color", "#ffffff"))
	vis.polygon = PackedVector2Array([
		Vector2(-12, -12), Vector2(12, -12), Vector2(12, 12), Vector2(-12, 12)
	])
	node.add_child(vis)
	var area := Area2D.new()
	var col := CollisionShape2D.new()
	var s := CircleShape2D.new()
	s.radius = 14.0
	col.shape = s
	area.add_child(col)
	node.add_child(area)
	_match.add_child(node)
	_active_pickups.append(node)

func _update_pickups(delta: float) -> void:
	var remaining: Array = []
	for p in _active_pickups:
		if not is_instance_valid(p):
			continue
		var lt: float = p.get_meta("lifetime") - delta
		p.set_meta("lifetime", lt)
		if lt <= 0.0:
			p.queue_free()
		else:
			remaining.append(p)
	_active_pickups = remaining

func _check_collection() -> void:
	if _ball == null:
		return
	for p in _active_pickups:
		if not is_instance_valid(p):
			continue
		if p.global_position.distance_to(_ball.global_position) <= GameConstants.PU_COLLECT_RADIUS:
			_apply_pu(_ball.last_touch_side, str(p.get_meta("pu_id")))
			p.queue_free()
			_active_pickups.erase(p)
			AudioManager.play_sfx("coin")
			break

func _apply_pu(collector_side: String, pu_id: String) -> void:
	var is_hero_collector := collector_side == "hero"
	match pu_id:
		"speed_good":
			banner_text.emit("Super Speed")
			var fx = hero_effects if is_hero_collector else opp_effects
			fx["speed"] = GameConstants.PU_DURATION_SHORT
			fx["speed_val"] = 2.0
		"speed_bad":
			banner_text.emit("Slow Speed")
			var fx = hero_effects if is_hero_collector else opp_effects
			fx["speed"] = GameConstants.PU_DURATION_SHORT
			fx["speed_val"] = 0.0
		"jump_good":
			banner_text.emit("Super Jump")
			var fx = hero_effects if is_hero_collector else opp_effects
			fx["jump"] = GameConstants.PU_DURATION_SHORT
			fx["jump_val"] = 2.0
		"jump_bad":
			banner_text.emit("Low Jump")
			var fx = hero_effects if is_hero_collector else opp_effects
			fx["jump"] = GameConstants.PU_DURATION_SHORT
			fx["jump_val"] = 0.0
		"ice_good":
			banner_text.emit("Freeze")
			var victim = opp_effects if is_hero_collector else hero_effects
			victim["ice"] = GameConstants.PU_DURATION_SHORT
		"ice_bad":
			banner_text.emit("Freeze")
			var fx = hero_effects if is_hero_collector else opp_effects
			fx["ice"] = GameConstants.PU_DURATION_SHORT
		"size_good":
			banner_text.emit("Big Head")
			var body = _hero if is_hero_collector else _opp
			var fx = hero_effects if is_hero_collector else opp_effects
			fx["size"] = GameConstants.PU_DURATION_BOMBS
			body.set_head_scale(1.5)
		"size_bad":
			banner_text.emit("Small Head")
			var body = _hero if is_hero_collector else _opp
			var fx = hero_effects if is_hero_collector else opp_effects
			fx["size"] = GameConstants.PU_DURATION_BOMBS
			body.set_head_scale(0.65)
		"break_good":
			banner_text.emit("Break Leg")
			var fx = opp_effects if is_hero_collector else hero_effects
			fx["break"] = GameConstants.PU_DURATION_BREAK_OPP if not is_hero_collector else GameConstants.PU_DURATION_BREAK_HERO
		"break_bad":
			banner_text.emit("Break Leg")
			var fx = hero_effects if is_hero_collector else opp_effects
			fx["break"] = GameConstants.PU_DURATION_BREAK_HERO
		"fire_neu":
			banner_text.emit("Bombs")
			neutral["fire"] = GameConstants.PU_DURATION_FIRE
		"bigball_neu":
			banner_text.emit("Big Ball")
			neutral["size"] = 2.0
			_ball.reset_ball_props(neutral["size"], neutral["bouncy"])
		"bouncy_neu":
			banner_text.emit("Bouncy Ball")
			neutral["bouncy"] = 2.0
			_ball.reset_ball_props(neutral["size"], neutral["bouncy"])
		"smallball_neu":
			banner_text.emit("Small Ball")
			neutral["size"] = 0.0
			_ball.reset_ball_props(neutral["size"], neutral["bouncy"])
		"deadball_neu":
			banner_text.emit("Dead Ball")
			neutral["bouncy"] = 0.0
			_ball.reset_ball_props(neutral["size"], neutral["bouncy"])
		"streaker_neu":
			banner_text.emit("Streaker")
			neutral["streaker"] = GameConstants.PU_DURATION_STREAKER
