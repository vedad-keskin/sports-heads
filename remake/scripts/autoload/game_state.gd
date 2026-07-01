extends Node
## Global session state — league, 2P config, match settings.

const DataLoader = preload("res://scripts/util/data_loader.gd")

enum Screen {
	MAIN_MENU,
	TWO_PLAYER_SETUP,
	TEAM_SELECT,
	SHOP,
	ACHIEVEMENTS,
	INSTRUCTIONS,
	MATCH,
	MATCH_RESULTS,
	SEASON_RESULTS,
}

enum GameType { TIMED, FIRST_TO_SEVEN, GOLDEN_GUN }
enum GoalVariant { REGULAR, BIG_GOALS, SMALL_GOALS }

var current_screen: Screen = Screen.MAIN_MENU
var two_player_mode: bool = false

# 2P setup
var tp_game_type: GameType = GameType.TIMED
var tp_goal_variant: GoalVariant = GoalVariant.REGULAR
var tp_pitch: int = 2
var tp_skin_p1: int = 1
var tp_skin_p2: int = 1

# League
var face_num: int = 1
var team_chosen: bool = false
var round_num: int = 1
var team_list: Array = []
var upgrade_list: Array = [[0, 0, 0, 0, 0, 0, 0], [], [], []]
var upgrade_points: int = 0
var upgrade_lock: bool = false
var special_heads_unlocked: bool = false
var bear_head: bool = false
var next_opponent_id: int = 2

# Last match results (for results screen)
var last_hero_score: int = 0
var last_opp_score: int = 0
var last_match_won: bool = false

func reset_league_from_data() -> void:
	team_list = []
	var teams_data: Array = DataLoader.load_json("res://data/teams.json")
	for t in teams_data:
		team_list.append([
			t["name"], t["ai_rating"], 0, 0, 0, 0, 0, 0, 0, t["id"]
		])
	team_chosen = false
	round_num = 1
	face_num = 1
	upgrade_points = 0
	upgrade_list = [[0, 0, 0, 0, 0, 0, 0], GameConstants.UPGRADE_COSTS.duplicate(), GameConstants.UPGRADE_NAMES.duplicate(), GameConstants.UPGRADE_MAX.duplicate()]
	next_opponent_id = 2

func get_player_team_name() -> String:
	if face_num <= 0 or face_num > team_list.size():
		return "Player"
	return str(team_list[face_num - 1][0])

func get_opponent_team_name() -> String:
	for t in team_list:
		if t[9] == next_opponent_id:
			return str(t[0])
	return "Opponent"
