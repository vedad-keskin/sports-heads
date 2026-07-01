extends Control

const LeagueManager = preload("res://scripts/league/league_manager.gd")

signal navigate(screen: GameState.Screen)

func _ready() -> void:
	var sorted := LeagueManager.sort_league(GameState.team_list)
	var text := "SEASON COMPLETE\n\n"
	for i in sorted.size():
		var you := " <-- YOU" if sorted[i][0] == GameState.get_player_team_name() else ""
		text += "%d. %s  %d pts%s\n" % [i + 1, sorted[i][0], sorted[i][2], you]
	if sorted.size() > 0 and sorted[0][0] == GameState.get_player_team_name():
		AchievementManager.award(12)
	$VBox/Text.text = text
	$VBox/Menu.pressed.connect(func(): navigate.emit(GameState.Screen.MAIN_MENU))
