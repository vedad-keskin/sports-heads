extends RefCounted
class_name LeagueManager

const DataLoader = preload("res://scripts/util/data_loader.gd")

static func parse_fixtures(raw: String) -> Array:
	var pairs: Array = []
	if raw.length() <= 12:
		return pairs
	var body := raw.substr(12)
	var i := 0
	while i + 4 < body.length():
		var a := body.substr(i, 2).to_int()
		var b := body.substr(i + 3, 2).to_int()
		pairs.append([a, b])
		i += 5
	return pairs

static func get_round_fixtures(round_idx: int) -> Array:
	var data = DataLoader.load_json("res://data/fixtures.json")
	if data == null:
		return []
	var rounds: Array = data.get("rounds", [])
	if round_idx < 1 or round_idx > rounds.size():
		return []
	return parse_fixtures(str(rounds[round_idx - 1]))

static func find_player_fixture(round_idx: int, player_team_id: int) -> Array:
	for pair in get_round_fixtures(round_idx):
		if pair[0] == player_team_id or pair[1] == player_team_id:
			return pair
	return []

static func simulate_match(team_a: Dictionary, team_b: Dictionary) -> Array:
	var ra: float = float(team_a[1])
	var rb: float = float(team_b[1])
	var ga := randi_range(0, 3)
	var gb := randi_range(0, 3)
	if ra > rb:
		ga += randi_range(0, 2)
	elif rb > ra:
		gb += randi_range(0, 2)
	return [ga, gb]

static func apply_result(team: Array, gf: int, ga: int) -> void:
	team[3] += 1
	team[7] += gf
	team[8] += ga
	if gf > ga:
		team[2] += 3
		team[4] += 1
	elif gf == ga:
		team[2] += 1
		team[5] += 1
	else:
		team[6] += 1

static func sort_league(teams: Array) -> Array:
	var copy := teams.duplicate(true)
	copy.sort_custom(func(a, b):
		if a[2] != b[2]:
			return a[2] > b[2]
		return (a[7] - a[8]) > (b[7] - b[8])
	)
	return copy

static func simulate_round(round_idx: int, player_team_id: int, player_gf: int, player_ga: int, opponent_id: int) -> void:
	for pair in get_round_fixtures(round_idx):
		var ta := _team_by_id(pair[0])
		var tb := _team_by_id(pair[1])
		if ta.is_empty() or tb.is_empty():
			continue
		if pair[0] == player_team_id or pair[1] == player_team_id:
			if pair[0] == player_team_id:
				apply_result(ta, player_gf, player_ga)
				apply_result(tb, player_ga, player_gf)
			else:
				apply_result(tb, player_gf, player_ga)
				apply_result(ta, player_ga, player_gf)
		else:
			var r := simulate_match(ta, tb)
			apply_result(ta, r[0], r[1])
			apply_result(tb, r[1], r[0])

static func _team_by_id(id: int) -> Array:
	for t in GameState.team_list:
		if t[9] == id:
			return t
	return []

static func find_next_opponent(player_team_id: int, round_idx: int) -> int:
	var fix := find_player_fixture(round_idx, player_team_id)
	if fix.is_empty():
		return 2
	return fix[1] if fix[0] == player_team_id else fix[0]
