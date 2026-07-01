extends Node

var _players: Dictionary = {}

func _ready() -> void:
	_register("kick", "res://assets/audio/5_KickSound.mp3")
	_register("jump", "res://assets/audio/6_JumpSound.mp3")
	_register("coin", "res://assets/audio/9_CoinSound.mp3")
	_register("explosion", "res://assets/audio/7_ExplosionSound.mp3")
	_register("die", "res://assets/audio/8_DieSound.mp3")
	_register("cheer", "res://assets/audio/10_CheerSound.mp3")
	_register("pop", "res://assets/audio/4_PopSound.mp3")
	_register("whistle", "res://assets/audio/3_WhistleSound.mp3")

var music_muted: bool = false
var sfx_muted: bool = false
var _music: AudioStreamPlayer

func _register(name: String, path: String) -> void:
	if FileAccess.file_exists(path):
		_players[name] = load(path)

func play_sfx(name: String) -> void:
	if sfx_muted or not _players.has(name):
		return
	var p := AudioStreamPlayer.new()
	p.stream = _players[name]
	add_child(p)
	p.play()
	p.finished.connect(p.queue_free)

func start_music() -> void:
	if music_muted:
		return
	if _music == null:
		_music = AudioStreamPlayer.new()
		add_child(_music)
	if FileAccess.file_exists("res://assets/audio/2_LoopSound.mp3"):
		_music.stream = load("res://assets/audio/2_LoopSound.mp3")
		_music.volume_db = -6.0
		if not _music.playing:
			_music.play()

func stop_music() -> void:
	if _music:
		_music.stop()
