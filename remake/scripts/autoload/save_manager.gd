extends Node

const DataLoader = preload("res://scripts/util/data_loader.gd")
const SAVE_PATH := "user://save.json"

var has_save: bool = false

func _ready() -> void:
	load_game()

func load_game() -> bool:
	if not FileAccess.file_exists(SAVE_PATH):
		has_save = false
		return false
	var data = DataLoader.load_json(SAVE_PATH)
	if data == null:
		has_save = false
		return false
	has_save = true
	GameState.team_list = data.get("team_list", [])
	GameState.face_num = int(data.get("face_num", 1))
	GameState.round_num = int(data.get("round", 1))
	GameState.team_chosen = bool(data.get("team_chosen", false))
	GameState.upgrade_list = data.get("upgrade_list", GameState.upgrade_list)
	GameState.upgrade_points = int(data.get("upgrade_points", 0))
	GameState.special_heads_unlocked = bool(data.get("special_heads", false))
	GameState.bear_head = bool(data.get("bear_head", false))
	AchievementManager.load_from_save(data.get("achievements", {}))
	return true

func save_game() -> void:
	has_save = true
	var data := {
		"file_created": true,
		"team_list": GameState.team_list,
		"face_num": GameState.face_num,
		"round": GameState.round_num,
		"team_chosen": GameState.team_chosen,
		"upgrade_list": GameState.upgrade_list,
		"upgrade_points": GameState.upgrade_points,
		"special_heads": GameState.special_heads_unlocked,
		"bear_head": GameState.bear_head,
		"achievements": AchievementManager.export_to_save(),
	}
	var f := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	f.store_string(JSON.stringify(data, "\t"))
	f.close()

func clear_save() -> void:
	has_save = false
	if FileAccess.file_exists(SAVE_PATH):
		DirAccess.remove_absolute(SAVE_PATH)

func can_continue() -> bool:
	return has_save and GameState.team_chosen and GameState.round_num < 62
