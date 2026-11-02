extends Node

const GAME_SCENE := "res://scenes/rooms/test.tscn"
const MAIN_MENU_SCENE := "res://scenes/UI/MainMenu.tscn"

@onready var music_player = $AudioStreamPlayer

var menu_music = preload("res://assets/VFX/music_menu.wav")
var dungeon_music = preload("res://assets/VFX/music_normal.wav")
var boss_music = preload("res://assets/VFX/music_boss.wav")
var victory_music = preload("res://assets/VFX/music_victory.wav")

var default_volume_db: float = 0.0

# Keep playing song
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	if music_player:
		default_volume_db = music_player.volume_db

func play_menu_music() -> void:
	_play(menu_music)

func play_dungeon_music() -> void:
	_play(dungeon_music)

func play_boss_music() -> void:
	_play(boss_music)

func play_victory_music() -> void:
	_play(victory_music)

# Play specific
func _play(stream: AudioStream) -> void:
	music_player.volume_db = default_volume_db
	
	if music_player.stream != stream:
		music_player.stream = stream
		music_player.play()
	elif not music_player.playing:
		music_player.play()
