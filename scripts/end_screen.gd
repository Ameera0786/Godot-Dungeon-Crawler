extends CanvasLayer

@export var fade_in_duration: float = 1.2
@onready var background_image: TextureRect = $TextureRect

@onready var restart_button: Button = $TextureRect/MainContainer/RestartButton
@onready var main_menu_button: Button = $TextureRect/MainContainer/MainMenuButton
@onready var exit_button: Button = $TextureRect/MainContainer/ExitButton

# On load, play music and fade in screen
func _ready() -> void:
	background_image.modulate.a = 0.0
	var tween = create_tween()
	MusicManager.play_victory_music()
	tween.tween_property(background_image, "modulate:a", 1.0, fade_in_duration)
	
	restart_button.pressed.connect(_on_play_again_pressed)
	main_menu_button.pressed.connect(_on_main_menu_pressed)
	exit_button.pressed.connect(_on_exit_pressed)

# Play again
func _on_play_again_pressed() -> void:
	get_tree().change_scene_to_file(MusicManager.GAME_SCENE)

# Main menu
func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file(MusicManager.MAIN_MENU_SCENE)

# Quit
func _on_exit_pressed() -> void:
	get_tree().quit()
