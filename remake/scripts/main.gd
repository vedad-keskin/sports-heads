extends Node

const SCENES := {
	GameState.Screen.MAIN_MENU: "res://scenes/menu/main_menu.tscn",
	GameState.Screen.TWO_PLAYER_SETUP: "res://scenes/menu/two_player_setup.tscn",
	GameState.Screen.TEAM_SELECT: "res://scenes/menu/team_select.tscn",
	GameState.Screen.SHOP: "res://scenes/menu/shop.tscn",
	GameState.Screen.ACHIEVEMENTS: "res://scenes/menu/achievements.tscn",
	GameState.Screen.INSTRUCTIONS: "res://scenes/menu/instructions.tscn",
	GameState.Screen.MATCH: "res://scenes/match/match.tscn",
	GameState.Screen.MATCH_RESULTS: "res://scenes/results/match_results.tscn",
	GameState.Screen.SEASON_RESULTS: "res://scenes/results/season_results.tscn",
}

@onready var container: Node = $ScreenContainer

func _ready() -> void:
	AudioManager.start_music()
	go_to(GameState.Screen.MAIN_MENU)

func go_to(screen: GameState.Screen) -> void:
	GameState.current_screen = screen
	for c in container.get_children():
		c.queue_free()
	var path: String = SCENES[screen]
	var scene: PackedScene = load(path)
	var inst = scene.instantiate()
	container.add_child(inst)
	if inst.has_signal("navigate"):
		inst.navigate.connect(_on_navigate)
	if inst.has_signal("start_match"):
		inst.start_match.connect(_on_start_match)

func _on_navigate(screen: GameState.Screen) -> void:
	go_to(screen)

func _on_start_match() -> void:
	go_to(GameState.Screen.MATCH)
