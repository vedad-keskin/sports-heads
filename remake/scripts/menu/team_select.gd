extends Control

const LeagueManager = preload("res://scripts/league/league_manager.gd")

signal navigate(screen: GameState.Screen)
signal start_match

func _ready() -> void:
	if GameState.team_list.is_empty():
		GameState.reset_league_from_data()
	_refresh()
	$VBox/TeamLeft.pressed.connect(_team_left)
	$VBox/TeamRight.pressed.connect(_team_right)
	$VBox/Choose.pressed.connect(_on_choose)
	$VBox/Shop.pressed.connect(func(): navigate.emit(GameState.Screen.SHOP))
	$VBox/LeagueBtn.pressed.connect(_refresh_table)
	if has_node("VBox/PlayMatch"):
		$VBox/PlayMatch.pressed.connect(_on_play_match)

func _refresh() -> void:
	var name := GameState.get_player_team_name() if GameState.team_chosen else "Choose Team"
	$VBox/TeamLabel.text = "Playing as: %s (#%d)" % [name, GameState.face_num]
	$VBox/RoundLabel.text = "Matchday: %d / 61" % GameState.round_num
	$VBox/PointsLabel.text = "Upgrade points: %d" % GameState.upgrade_points
	if GameState.team_chosen:
		GameState.next_opponent_id = LeagueManager.find_next_opponent(
			GameState.team_list[GameState.face_num - 1][9], GameState.round_num
		)
		$VBox/OpponentLabel.text = "Next: %s" % GameState.get_opponent_team_name()
		$VBox/PlayMatch.visible = true
	else:
		$VBox/OpponentLabel.text = ""
		$VBox/PlayMatch.visible = false

func _team_left() -> void:
	GameState.face_num = wrapi(GameState.face_num - 1, 1, 21)
	_refresh()

func _team_right() -> void:
	GameState.face_num = wrapi(GameState.face_num + 1, 1, 21)
	_refresh()

func _on_choose() -> void:
	GameState.team_chosen = true
	SaveManager.save_game()
	_refresh()

func _refresh_table() -> void:
	var sorted := LeagueManager.sort_league(GameState.team_list)
	var text := "League table:\n"
	for i in sorted.size():
		text += "%d. %s  %d pts\n" % [i + 1, sorted[i][0], sorted[i][2]]
	$VBox/TableLabel.text = text

func _on_play_match() -> void:
	start_match.emit()
