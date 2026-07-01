extends Node2D

func _ready() -> void:
	match_finished.connect(_on_finished)

func _on_finished(_h: int, _o: int) -> void:
	get_tree().root.get_node("Main").go_to(GameState.Screen.MATCH_RESULTS)
