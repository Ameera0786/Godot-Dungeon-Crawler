extends Control

const GAME_SCENE := "res://scenes/rooms/test.tscn"

@onready var start_button: Button = $Background/MainContainer/StartButton
@onready var settings_button: Button = $Background/MainContainer/SettingsButton
@onready var settings_menu: CanvasLayer = $SettingsMenu

# Start up, show main menu
func _ready() -> void:
	HUD.visible = false
	MusicManager.play_menu_music()
	start_button.pressed.connect(_on_start_pressed)
	settings_button.pressed.connect(settings_menu.open)
	settings_menu.closed.connect(settings_button.grab_focus)
	start_button.grab_focus()

# Start game
func _on_start_pressed() -> void:
	HUD.visible = true
	MusicManager.play_dungeon_music()
	get_tree().change_scene_to_file(GAME_SCENE)
