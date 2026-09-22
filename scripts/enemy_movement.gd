extends CharacterBody2D

# Movement
@export_group("Movement")
@export var speed := 70.0

# Enemy
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_hit_box: Node2D = find_child("*AttackHit*", true, false)
@onready var detection_area: Area2D = find_child("*Interaction*", true, false)
@onready var combat: Node = $Combat

# Variables
var player: CharacterBody2D = null

# Initial load in
func _ready() -> void:
	add_to_group("enemy")

	detection_area.body_entered.connect(_on_detection_area_body_entered)
	detection_area.body_exited.connect(_on_detection_area_body_exited)

# Collisions
func _physics_process(_delta: float) -> void:
	if combat.is_dead or combat.is_hurt:
		return

	handle_movement()
	combat.check_attack(player)
	update_animation()
	move_and_slide()

# Flip enemy based on direction and move animations
func handle_movement() -> void:
	if player == null or combat.is_attacking:
		velocity = Vector2.ZERO
		return

	var distance = global_position.distance_to(player.global_position)

	if distance > combat.attack_range:
		var direction = global_position.direction_to(player.global_position)
		velocity = direction * speed

		if direction.x < 0:
			sprite.flip_h = true
			attack_hit_box.scale.x = -1
		elif direction.x > 0:
			sprite.flip_h = false
			attack_hit_box.scale.x = 1
	else:
		velocity = Vector2.ZERO

# Reset animation
func update_animation() -> void:
	if combat.is_attacking:
		return

	if velocity != Vector2.ZERO:
		sprite.play("walk")
	else:
		sprite.play("idle")

# Detect player entering zone
func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body as CharacterBody2D

# Detect player leaving zone
func _on_detection_area_body_exited(body: Node2D) -> void:
	if body == player:
		player = null

# Delegate take_damage call from player attacks to Combat
func take_damage(amount: int) -> void:
	combat.take_damage(amount)
