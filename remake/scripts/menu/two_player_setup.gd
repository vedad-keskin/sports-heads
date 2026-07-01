extends Control

signal navigate(screen: GameState.Screen)
signal start_match

const GAME_TYPES := ["Timed", "First to 7", "Golden Gun"]
const GOAL_TYPES := ["Regular", "Big Goals", "Small Goals"]

func _ready() -> void:
	_refresh()
	$VBox/GameTypeBtn.pressed.connect(_cycle_game_type)
	$VBox/GoalTypeBtn.pressed.connect(_cycle_goal_type)
	$VBox/HBoxPitch/PitchLeft.pressed.connect(func(): _change_pitch(-1))
	$VBox/HBoxPitch/PitchRight.pressed.connect(func(): _change_pitch(1))
	$VBox/HBoxS1/Skin1Left.pressed.connect(func(): _change_skin(1, -1))
	$VBox/HBoxS1/Skin1Right.pressed.connect(func(): _change_skin(1, 1))
	$VBox/HBoxS2/Skin2Left.pressed.connect(func(): _change_skin(2, -1))
	$VBox/HBoxS2/Skin2Right.pressed.connect(func(): _change_skin(2, 1))
	$VBox/Start.pressed.connect(_on_start)
	$VBox/Back.pressed.connect(func(): navigate.emit(GameState.Screen.MAIN_MENU))

func _refresh() -> void:
	$VBox/GameTypeBtn.text = "Mode: " + GAME_TYPES[GameState.tp_game_type]
	$VBox/GoalTypeBtn.text = "Goals: " + GOAL_TYPES[GameState.tp_goal_variant]
	$VBox/PitchLabel.text = "Pitch: %d" % GameState.tp_pitch
	$VBox/Skin1Label.text = "P1 Head: %d" % GameState.tp_skin_p1
	$VBox/Skin2Label.text = "P2 Head: %d" % GameState.tp_skin_p2

func _cycle_game_type() -> void:
	GameState.tp_game_type = (GameState.tp_game_type + 1) % 3
	_refresh()

func _cycle_goal_type() -> void:
	GameState.tp_goal_variant = (GameState.tp_goal_variant + 1) % 3
	_refresh()

func _change_pitch(d: int) -> void:
	GameState.tp_pitch = clampi(GameState.tp_pitch + d, 2, 20)
	_refresh()

func _change_skin(player: int, d: int) -> void:
	var max_s := 28 if GameState.special_heads_unlocked else 19
	if player == 1:
		GameState.tp_skin_p1 = clampi(GameState.tp_skin_p1 + d, 1, max_s)
	else:
		GameState.tp_skin_p2 = clampi(GameState.tp_skin_p2 + d, 1, max_s)
	_refresh()

func _on_start() -> void:
	start_match.emit()
