extends Node2D

# Stats
@export_group("Combat Stats")
@export var max_health := 80
@export var attack_range := 220.0
@export var attack_cooldown := 2.0
@export var cast_frame := 3
@export var soul_reward := 1.0

@export_group("Resources")
@export var projectile_scene: PackedScene

# Nodes
@onready var enemy: CharacterBody2D = get_parent()
@onready var sprite: AnimatedSprite2D = $"../AnimatedSprite2D"
@onready var spawn_point: Marker2D = $"../AttackHitBox"
@onready var attack_sound: AudioStreamPlayer = $"../AttackSound"
@onready var death_sound: AudioStreamPlayer = $"../DeathSound"
@onready var hurt_sound: AudioStreamPlayer = $"../HurtSound"

# Variables
var health: int
var player: CharacterBody2D = null
var is_attacking := false
var is_dead := false
var is_hurt := false
var has_fired := false
var cooldown_left := 0.0

# Initial load in
func _ready() -> void:
	health = max_health
	sprite.frame_changed.connect(_on_frame_changed)
	sprite.animation_finished.connect(_on_animation_finished)

# Cooldown
func _physics_process(delta: float) -> void:
	if cooldown_left > 0.0:
		cooldown_left -= delta

# Check if can attack
func check_attack(target_player: CharacterBody2D) -> void:
	if target_player != null:
		player = target_player

	if player == null or is_attacking or is_dead or is_hurt or cooldown_left > 0.0:
		return

	if enemy.global_position.distance_to(player.global_position) <= attack_range:
		start_attack()

# Attack
func start_attack() -> void:
	is_attacking = true
	has_fired = false
	enemy.velocity = Vector2.ZERO
	sprite.play("attack")
	attack_sound.play()

# Release ball
func _on_frame_changed() -> void:
	if sprite.animation == "attack" and sprite.frame == cast_frame and is_attacking and not has_fired:
		fire_projectile()

# Create ball
func fire_projectile() -> void:
	has_fired = true
	if projectile_scene == null or player == null:
		return

	var ball = projectile_scene.instantiate()
	ball.global_position = spawn_point.global_position
	ball.direction = (player.global_position - spawn_point.global_position).normalized()
	get_tree().current_scene.add_child(ball)

# On animation finished
func _on_animation_finished() -> void:
	if sprite.animation == "hurt":
		is_hurt = false
	elif sprite.animation == "attack":
		is_attacking = false
		cooldown_left = attack_cooldown
	elif sprite.animation == "death":
		enemy.queue_free()

# Take damage
func take_damage(amount: int) -> void:
	if is_dead:
		return

	health -= amount
	is_attacking = false
	is_hurt = true
	cooldown_left = max(cooldown_left, 0.5)
	attack_sound.stop()

	if health <= 0:
		die()
	else:
		sprite.play("hurt")
		hurt_sound.play()

# Die
func die() -> void:
	if is_dead:
		return

	is_dead = true
	is_attacking = false
	is_hurt = false
	enemy.velocity = Vector2.ZERO
	enemy.remove_from_group("enemy")
	sprite.play("death")
	death_sound.play()

	var final_souls = PlayerStats.get_stat("soul", float(soul_reward))
	PlayerStats.add_souls(final_souls)
