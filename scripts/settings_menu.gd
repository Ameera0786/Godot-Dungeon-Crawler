extends CanvasLayer

signal closed

## Turn both off on the main menu.
@export var pause_game: bool = true
@export var esc_toggles: bool = true

@onready var volume_slider: HSlider = %VolumeSlider
@onready var brightness_slider: HSlider = %BrightnessSlider
@onready var close_button: Button = %CloseSettingsButton

# Initial values
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS 
	visible = false

	volume_slider.min_value = 0.0
	volume_slider.max_value = 1.0
	volume_slider.step = 0.01

	brightness_slider.min_value = Settings.MIN_BRIGHTNESS
	brightness_slider.max_value = 1.0
	brightness_slider.step = 0.01

	close_button.pressed.connect(close)
	volume_slider.value_changed.connect(Settings.set_volume)
	brightness_slider.value_changed.connect(Settings.set_brightness)

# Cancels
func _unhandled_input(event: InputEvent) -> void:
	if esc_toggles and event.is_action_pressed("ui_cancel"):
		toggle()
		get_viewport().set_input_as_handled()

# Open settings
func open() -> void:
	volume_slider.set_value_no_signal(Settings.volume)
	brightness_slider.set_value_no_signal(Settings.brightness)
	visible = true
	if pause_game:
		get_tree().paused = true

# Close settings
func close() -> void:
	Settings.save_settings()
	visible = false
	if pause_game:
		get_tree().paused = false
	closed.emit()

# Turn on and off
func toggle() -> void:
	if visible:
		close()
	else:
		open()
