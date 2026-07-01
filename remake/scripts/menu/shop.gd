extends Control

signal navigate(screen: GameState.Screen)

func _ready() -> void:
	_build_shop()
	$VBox/Back.pressed.connect(func(): navigate.emit(GameState.Screen.TEAM_SELECT))

func _build_shop() -> void:
	var box: VBoxContainer = $VBox/UpgradeList
	for c in box.get_children():
		c.queue_free()
	for i in range(GameConstants.UPGRADE_NAMES.size()):
		var name: String = GameConstants.UPGRADE_NAMES[i]
		var level: int = GameState.upgrade_list[0][i] if GameState.upgrade_list[0].size() > i else 0
		var max_l: int = GameConstants.UPGRADE_MAX[i]
		var cost: int = GameConstants.UPGRADE_COSTS[i]
		var btn := Button.new()
		btn.text = "%s  Lv%d/%d  (%d pts)" % [name, level, max_l, cost]
		btn.disabled = level >= max_l or GameState.upgrade_points < cost or cost == 0
		var idx := i
		btn.pressed.connect(func(): _buy(idx, cost))
		box.add_child(btn)
	$VBox/Points.text = "Points: %d" % GameState.upgrade_points

func _buy(index: int, cost: int) -> void:
	if GameState.upgrade_points < cost:
		return
	if GameState.upgrade_list[0][index] >= GameConstants.UPGRADE_MAX[index]:
		return
	GameState.upgrade_points -= cost
	GameState.upgrade_list[0][index] += 1
	SaveManager.save_game()
	_build_shop()
