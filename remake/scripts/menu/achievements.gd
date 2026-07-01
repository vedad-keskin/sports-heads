extends Control

signal navigate(screen: GameState.Screen)

func _ready() -> void:
	var text := ""
	for i in range(17):
		var id := i + 1
		var mark := "[X]" if AchievementManager.unlocked.get(id, false) else "[ ]"
		text += "%s %d. %s\n" % [mark, id, AchievementManager.get_achievement_name(id)]
	$VBox/List.text = text
	$VBox/Back.pressed.connect(func(): navigate.emit(GameState.Screen.MAIN_MENU))
