extends Node

@onready var music_player = $AudioStreamPlayer

var menu_music = preload("res://assets/VFX/music_menu.wav")
var dungeon_music = preload("res://assets/VFX/music_normal.wav")
var boss_music = preload("res://assets/VFX/music_boss.wav")

# Keep playing song
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func play_menu_music() -> void:
	_play(menu_music)

func play_dungeon_music() -> void:
	_play(dungeon_music)

func play_boss_music() -> void:
	_play(boss_music)

# Play specific
func _play(stream: AudioStream) -> void:
	if music_player.stream != stream:
		music_player.stream = stream
		music_player.play()
	elif not music_player.playing:
		music_player.play()
