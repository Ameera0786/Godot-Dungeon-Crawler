class_name EnemyCombat
extends Node2D

# Export variables
@export_group("Combat Stats")
@export var max_health := 100
@export var attack_damage := 10
@export var attack_range := 50.0
@export var attack_pause := 0.4
@export var attack_hit_frames: Array[int] = [4, 5]

# Enemy
@onready var enemy: CharacterBody2D = get_parent()
@onready var sprite: AnimatedSprite2D = $"../AnimatedSprite2D"
@onready var attack_hit_box: Area2D = $"../AttackHitBox"
@onready var attack_collision: CollisionShape2D = $"../AttackHitBox/CollisionShape2D"

# Variables
var health: int
var is_attacking := false
var is_dead := false
var is_hurt := false

# Initial load in
func _ready() -> void:
	health = max_health
	attack_collision.disabled = true
	
	attack_hit_box.body_entered.connect(_on_attack_hit_box_body_entered)
	sprite.frame_changed.connect(_on_sprite_frame_changed)
	sprite.animation_finished.connect(_on_sprite_animation_finished)

# See if enemy can attack
func check_attack(player: CharacterBody2D) -> void:
	if player == null or is_attacking or is_dead:
		return

	var distance = enemy.global_position.distance_to(player.global_position)
	if distance <= attack_range:
		start_attack(player)

# Attack player
func start_attack(player: CharacterBody2D) -> void:
	is_attacking = true
	enemy.velocity = Vector2.ZERO
	sprite.play("attack")

# Disable frames as needed
func _on_sprite_frame_changed() -> void:
	if sprite.animation != "attack":
		attack_collision.disabled = true
		return

	attack_collision.disabled = not (sprite.frame in attack_hit_frames)

func _on_sprite_animation_finished() -> void:
	on_animation_finished(null, false)
	
# Animation finished
func on_animation_finished(player: CharacterBody2D, touching_player: bool) -> void:
	if sprite.animation == "hurt":
		is_hurt = false
		if player != null:
			check_attack(player)
		else:
			sprite.play("idle") 
	elif sprite.animation == "attack":
		is_attacking = false
		attack_collision.disabled = true

		if player != null and (
			touching_player or enemy.global_position.distance_to(player.global_position) <= attack_range
		):
			await get_tree().create_timer(attack_pause).timeout

			if player != null and not is_dead and (
				touching_player or enemy.global_position.distance_to(player.global_position) <= attack_range
			):
				start_attack(player)

	elif sprite.animation == "death":
		enemy.queue_free()

# Enemy close enough to play
func _on_attack_hit_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and body.has_method("take_damage"):
		print("Enemy hit player for ", attack_damage, " damage")
		body.take_damage(attack_damage)

# Enemy takes damage
func take_damage(amount: int) -> void:
	if is_dead:
		return

	health -= amount
	is_attacking = false
	is_hurt = true
	print("Enemy took ", amount, " damage")
	print("Enemy health: ", health, " / ", max_health)

	if health <= 0:
		die()
	else:
		sprite.play("hurt")

# Enemy dies
func die() -> void:
	if is_dead:
		return
	is_dead = true
	
	enemy.remove_from_group("enemies")
	enemy.velocity = Vector2.ZERO
	attack_collision.disabled = true
	sprite.play("death")
