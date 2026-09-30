extends Node

@onready var music_player = $AudioStreamPlayer

var dungeon_music = preload("res://assets/VFX/music_normal.wav")
var boss_music = preload("res://assets/VFX/music_boss.wav")

func play_dungeon_music():
	if music_player.stream != dungeon_music:
		music_player.stream = dungeon_music
		music_player.play()


func play_boss_music():
	if music_player.stream != boss_music:
		music_player.stream = boss_music
		music_player.play()
