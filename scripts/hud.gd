extends CanvasLayer

# Health Bar
@onready var health_bar: ProgressBar = $Control/HealthBar
@onready var settings_button: TextureButton = $SettingsButton
@onready var settings_menu: CanvasLayer = $SettingsMenu

func _ready() -> void:
	settings_button.pressed.connect(settings_menu.open)
	settings_menu.closed.connect(settings_button.grab_focus)

# Update health bar
func update_health(current_hp: int, max_hp: int) -> void:
	if health_bar == null:
		return
	
	health_bar.max_value = max_hp
	health_bar.value = current_hp
