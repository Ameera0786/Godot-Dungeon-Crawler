extends CanvasLayer

signal closed

## Turn both off on the main menu.
@export var pause_game: bool = true
@export var use_dimmer: bool = true

@onready var volume_slider: HSlider = %VolumeSlider
@onready var brightness_slider: HSlider = %BrightnessSlider
@onready var close_button: Button = %CloseButton
@onready var dimmer: Control = $Dimmer

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

# Open settings
func open() -> void:
	volume_slider.set_value_no_signal(Settings.volume)
	brightness_slider.set_value_no_signal(Settings.brightness)
	visible = true
	if dimmer:
		dimmer.visible = use_dimmer
	if pause_game:
		get_tree().paused = true

# Close settings
func close() -> void:
	Settings.save_settings()
	visible = false
	if pause_game:
		get_tree().paused = false
	closed.emit()
