extends Control

signal navigate(screen: GameState.Screen)
signal start_match

func _ready() -> void:
	$VBox/NewGame.pressed.connect(_on_new)
	$VBox/Continue.pressed.connect(_on_continue)
	$VBox/TwoPlayer.pressed.connect(_on_2p)
	$VBox/Achievements.pressed.connect(func(): navigate.emit(GameState.Screen.ACHIEVEMENTS))
	$VBox/Instructions.pressed.connect(func(): navigate.emit(GameState.Screen.INSTRUCTIONS))
	$VBox/Continue.disabled = not SaveManager.can_continue()

func _on_new() -> void:
	GameState.two_player_mode = false
	GameState.reset_league_from_data()
	SaveManager.save_game()
	navigate.emit(GameState.Screen.TEAM_SELECT)

func _on_continue() -> void:
	GameState.two_player_mode = false
	SaveManager.load_game()
	navigate.emit(GameState.Screen.TEAM_SELECT)

func _on_2p() -> void:
	GameState.two_player_mode = true
	navigate.emit(GameState.Screen.TWO_PLAYER_SETUP)
