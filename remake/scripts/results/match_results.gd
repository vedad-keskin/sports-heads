extends Control

signal navigate(screen: GameState.Screen)

func _ready() -> void:
	var won := GameState.last_match_won
	$VBox/Result.text = "Final: %d - %d\n%s" % [
		GameState.last_hero_score,
		GameState.last_opp_score,
		"YOU WIN!" if won else "YOU LOSE"
	]
	if GameState.two_player_mode:
		$VBox/Continue.text = "Main Menu"
		$VBox/Continue.pressed.connect(func(): navigate.emit(GameState.Screen.MAIN_MENU))
	else:
		if GameState.round_num >= 62:
			$VBox/Continue.text = "Season Results"
			$VBox/Continue.pressed.connect(func(): navigate.emit(GameState.Screen.SEASON_RESULTS))
		else:
			$VBox/Continue.text = "Continue League"
			$VBox/Continue.pressed.connect(func(): navigate.emit(GameState.Screen.TEAM_SELECT))
