extends Node

var unlocked: Dictionary = {}

const NAMES: Array[String] = [
	"Tight Defence", "Could Have Happened to Anyone", "Force Own Goal",
	"Last Gasp Clearance", "Last Second Winner", "Great Start",
	"Two Sports Heads", "Have a go Spadge", "Header Goal",
	"Come Back King", "Naked Ambition", "Champion!",
	"Flying Volley", "The Zola", "It just about fits",
	"Old Big Head", "Wrong Ball",
]

func _ready() -> void:
	for i in range(17):
		unlocked[i + 1] = false

func load_from_save(data: Dictionary) -> void:
	for i in range(17):
		var key := "ach%d" % (i + 1)
		unlocked[i + 1] = bool(data.get(key, false))

func export_to_save() -> Dictionary:
	var d := {}
	for i in range(17):
		d["ach%d" % (i + 1)] = unlocked[i + 1]
	return d

func award(id: int) -> void:
	if id < 1 or id > 17:
		return
	if unlocked.get(id, false):
		return
	unlocked[id] = true
	if id == 12:
		GameState.special_heads_unlocked = true
	AudioManager.play_sfx("coin")
	SaveManager.save_game()

func get_achievement_name(id: int) -> String:
	if id >= 1 and id <= NAMES.size():
		return NAMES[id - 1]
	return "Achievement %d" % id
