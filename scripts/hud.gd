extends CanvasLayer

@onready var health_bar: ProgressBar = $Control/HealthBar

func _ready() -> void:
	# Optional: register HUD to receive health updates automatically
	pass

func update_health(current_hp: int, max_hp: int) -> void:
	if health_bar == null:
		return
	health_bar.max_value = max_hp
	health_bar.value = current_hp
