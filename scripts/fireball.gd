extends Area2D

# Exports
@export var speed: float = 250.0
@export var damage: int = 30
@onready var impact_sound: AudioStreamPlayer = $ImpactSound

# Variables
var direction: Vector2 = Vector2.ZERO

# Initial load in
func _ready() -> void:
	if direction != Vector2.ZERO:
		rotation = direction.angle()

# Move fireball
func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta

# Fireball hits player
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if body.has_method("take_damage"):
			body.take_damage(damage)
		play_impact_sound()
		queue_free()
	elif body is TileMapLayer:
		play_impact_sound()
		queue_free()

func play_impact_sound() -> void:
	var sound = impact_sound.duplicate()
	get_tree().current_scene.add_child(sound)
	sound.play()
	sound.finished.connect(sound.queue_free)
