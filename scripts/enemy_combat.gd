class_name EnemyCombat
extends Node2D

# Export variables
@export_group("Combat Stats")
@export var max_health := 100
@export var attack_damage := 10
@export var attack_range := 50.0
@export var attack_pause := 0.4
@export var attack_hit_frames: Array[int] = [4, 5]
@onready var attack_sound: AudioStreamPlayer = $"../AttackSound"
@onready var death_sound: AudioStreamPlayer = $"../DeathSound"
@onready var hurt_sound: AudioStreamPlayer = $"../HurtSound"

# Enemy
@onready var enemy: CharacterBody2D = get_parent()
@onready var sprite: AnimatedSprite2D = $"../AnimatedSprite2D"
@onready var attack_hit_box: Area2D = $"../AttackHitBox"
@onready var attack_collision: CollisionShape2D = $"../AttackHitBox/CollisionShape2D"

# Variables
var health: int
var player: CharacterBody2D = null
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
func check_attack(target_player: CharacterBody2D) -> void:
	if target_player != null:
		player = target_player
	
	if player == null or is_attacking or is_dead:
		return

	var distance = enemy.global_position.distance_to(player.global_position)
	if distance <= attack_range:
		start_attack()

# Attack player
func start_attack() -> void:
	if is_dead or is_hurt or is_attacking:
		return
	
	is_attacking = true
	enemy.velocity = Vector2.ZERO
	sprite.play("attack")
	await get_tree().create_timer(0.45).timeout
	attack_sound.play()
	

# Disable frames as needed
func _on_sprite_frame_changed() -> void:
	if sprite.animation != "attack":
		attack_collision.disabled = true
		return

	attack_collision.disabled = not (sprite.frame in attack_hit_frames)
	
# Animation finished
func _on_sprite_animation_finished() -> void:
	if sprite.animation == "hurt":
		is_hurt = false
		if player != null:
			check_attack(player)
		else:
			sprite.play("idle") 
	elif sprite.animation == "attack":
		is_attacking = false
		attack_collision.disabled = true

		if player != null and not is_dead:
			var distance = enemy.global_position.distance_to(player.global_position) 
			if distance <= attack_range:
				await get_tree().create_timer(attack_pause).timeout

				if player != null and not is_dead and not is_hurt:
					distance = enemy.global_position.distance_to(player.global_position) 
					if distance <= attack_range:
						start_attack()
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
	
	attack_collision.disabled = true
	
	print("Enemy took ", amount, " damage")
	print("Enemy health: ", health, " / ", max_health)

	if health <= 0:
		die()
	else:
		sprite.play("hurt")
		hurt_sound.play()

# Enemy dies
func die() -> void:
	if is_dead:
		return
	
	is_dead = true
	is_attacking = false
	is_hurt = false
	
	enemy.velocity = Vector2.ZERO
	attack_collision.disabled = true
	
	enemy.remove_from_group("enemy")
	sprite.play("death")
	death_sound.play()
	
