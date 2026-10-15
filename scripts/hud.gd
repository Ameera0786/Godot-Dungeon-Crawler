extends CanvasLayer

# Health Bar
@onready var health_bar: ProgressBar = $Control/HealthBar
@onready var health_label: Label = $Control/HealthBar/HealthLabel
@onready var pause_button: TextureButton = $PauseButton
@onready var pause_menu: CanvasLayer = $PauseMenu

func _ready() -> void:
	pause_button.pressed.connect(pause_menu.open)
	pause_menu.closed.connect(pause_button.grab_focus)

# Update health bar
func update_health(current_hp: int, max_hp: int) -> void:
	if health_bar == null:
		return
	
	health_bar.max_value = max_hp
	health_bar.value = current_hp
	health_label.text = "%d / %d" % [current_hp, max_hp]
