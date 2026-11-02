extends Control

@onready var start_button: Button = $Background/MainContainer/StartButton
@onready var settings_button: Button = $Background/MainContainer/SettingsButton
@onready var skill_tree_button: Button = $Background/MainContainer/SkillTreeButton
@onready var settings_menu: CanvasLayer = $SettingsMenu
@onready var skill_tree_menu: CanvasLayer = $SkillTreeMenu
@onready var reset_button: Button = $Background/MainContainer/ResetButton

# Start up, show main menu
func _ready() -> void:
	HUD.visible = false
	MusicManager.play_menu_music()
	start_button.pressed.connect(_on_start_pressed)
	
	settings_button.pressed.connect(settings_menu.open)
	settings_menu.closed.connect(settings_button.grab_focus)
	
	skill_tree_button.pressed.connect(skill_tree_menu.open)
	skill_tree_menu.closed.connect(skill_tree_button.grab_focus)
	
	reset_button.pressed.connect(_on_reset_pressed)
	
	start_button.grab_focus()

# Start game
func _on_start_pressed() -> void:
	HUD.visible = true
	MusicManager.play_dungeon_music()
	get_tree().change_scene_to_file(MusicManager.GAME_SCENE)

# Reset stats
func _on_reset_pressed() -> void:
	PlayerStats.reset()
