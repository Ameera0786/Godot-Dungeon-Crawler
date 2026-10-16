extends CanvasLayer

signal closed

@export var pause_game: bool = true
@export var esc_toggles: bool = true

@onready var close_button: Button = %CloseButton
@onready var pause_menu: CanvasLayer = $"."

@onready var settings_menu: CanvasLayer = $SettingsMenu
@onready var main_menu_button: TextureButton = $Dimmer/PausePanel/Rows/MainMenuButton
@onready var settings_button: TextureButton = $Dimmer/PausePanel/Rows/SettingsButton

# Initial values
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS 
	visible = false
	
	close_button.pressed.connect(close)
	settings_button.pressed.connect(settings_menu.open)
	settings_menu.closed.connect(settings_button.grab_focus)

# Use esc to toggle
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and not event.echo and event.keycode == KEY_ESCAPE:
			if not esc_toggles:
				return
	
	if esc_toggles and event.is_action_pressed("ui_cancel"):
		var current_scene = get_tree().current_scene
		if current_scene and current_scene.scene_file_path.get_file() == "MainMenu.tscn":
			return
		
		var death_menu = current_scene.get_node_or_null("DeathMenu")
		if death_menu and death_menu.visible:
			return
		
		toggle()
		get_viewport().set_input_as_handled()

# Open settings
func open() -> void:
	visible = true
	if pause_game:
		get_tree().paused = true

# Close settings
func close() -> void:
	if settings_menu.has_method("close"):
		settings_menu.close()
	else:
		settings_menu.visible = false
	
	visible = false
	if pause_game:
		get_tree().paused = false
	closed.emit()

# Go to main menu
func _on_main_menu_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/UI/MainMenu.tscn")
	close()

# Turn on and off
func toggle() -> void:
	if visible:
		close()
	else:
		open()
