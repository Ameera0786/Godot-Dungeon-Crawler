extends CanvasLayer

# Health Bar
@onready var health_bar: ProgressBar = $Control/HealthBar

# Update health bar
func update_health(current_hp: int, max_hp: int) -> void:
	if health_bar == null:
		return
	
	health_bar.max_value = max_hp
	health_bar.value = current_hp
