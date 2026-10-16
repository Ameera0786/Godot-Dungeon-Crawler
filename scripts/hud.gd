extends CanvasLayer

# Health Bar
@onready var health_bar: ProgressBar = $Control/HealthBar
@onready var health_label: Label = $Control/HealthBar/HealthLabel

@onready var boss_health_bar: ProgressBar = $BossHealthBar
@onready var boss_health_label: Label = $BossHealthBar/BossHealthLabel

@onready var pause_button: TextureButton = $PauseButton
@onready var pause_menu: CanvasLayer = $PauseMenu

# Initial
func _ready() -> void:
	pause_button.pressed.connect(pause_menu.open)
	pause_menu.closed.connect(pause_button.grab_focus)
	
	boss_health_bar.visible = false

# Update health bar
func update_health(current_hp: float, max_hp: float) -> void:
	if health_bar == null:
		return
	
	health_bar.max_value = max_hp
	health_bar.value = current_hp
	health_label.text = "%d / %d" % [current_hp, max_hp]

func show_boss_health() -> void:
	boss_health_bar.visible = true
	
func update_boss_health(current_hp: float, max_hp: float) -> void:
	boss_health_bar.max_value = max_hp
	boss_health_bar.value = current_hp
	boss_health_label.text = "%d / %d" % [current_hp, max_hp]
	
func close_boss_health():
	boss_health_bar.visible = false
