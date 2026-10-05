extends Node

const SAVE_PATH := "user://settings.cfg"
const MIN_BRIGHTNESS := 0.3

var volume: float = 1.0
var brightness: float = 1.0
var _overlay: ColorRect

# Load in settings
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

	var layer := CanvasLayer.new()
	layer.layer = 5
	add_child(layer)

	_overlay = ColorRect.new()
	_overlay.color = Color(0, 0, 0, 0)
	_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	layer.add_child(_overlay)

	load_settings()
	set_volume(volume)
	set_brightness(brightness)

# Set volume
func set_volume(value: float) -> void:
	volume = clampf(value, 0.0, 1.0)
	var bus := AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(bus, linear_to_db(volume))
	AudioServer.set_bus_mute(bus, volume == 0.0)

# Set brightness
func set_brightness(value: float) -> void:
	brightness = clampf(value, MIN_BRIGHTNESS, 1.0)
	_overlay.color.a = 1.0 - brightness

# Save settings
func save_settings() -> void:
	var config := ConfigFile.new()
	config.set_value("audio", "volume", volume)
	config.set_value("video", "brightness", brightness)
	config.save(SAVE_PATH)

# Load settings
func load_settings() -> void:
	var config := ConfigFile.new()
	if config.load(SAVE_PATH) != OK:
		return
	volume = config.get_value("audio", "volume", 1.0)
	brightness = config.get_value("video", "brightness", 1.0)
