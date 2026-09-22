extends Node2D

@export_group("Stats")
@export var max_health: int = 100
@export var attack_cooldown: float = 2.0
@export var attack_range: float = 150.0

@export_group("Resources")
@export var fireball_scene: PackedScene 

@onready var boss: CharacterBody2D = get_parent()
@onready var spawn_point: Node2D = $"../AttackHitBox"
@onready var animated_sprite: AnimatedSprite2D = $"../AnimatedSprite2D"

var current_health: int
var is_dead: bool = false
var is_hurt: bool = false
var is_attacking: bool = false

var player: Node2D = null
var can_shoot: bool = true

func _ready() -> void:
	current_health = max_health
	player = get_tree().get_first_node_in_group("player")

# Called continuously by enemy_movement.gd
func check_attack(target_player: Node2D) -> void:
	if target_player != null:
		player = target_player

	if player == null or not can_shoot or is_dead or is_hurt or is_attacking:
		return
	
	var distance = global_position.distance_to(player.global_position)
	if distance <= attack_range:
		shoot_fireball()

func shoot_fireball() -> void:
	if not fireball_scene or player == null:
		return

	can_shoot = false
	
	is_attacking = true
	animated_sprite.play("attack")
	create_fireball()
	
	# Brief delay during animation before returning to move state
	await get_tree().create_timer(0.5).timeout
	is_attacking = false
	
	# Cooldown timer before next shot
	await get_tree().create_timer(attack_cooldown).timeout
	can_shoot = true

# Create new fireball
func create_fireball():
	var fireball = fireball_scene.instantiate()
	fireball.global_position = spawn_point.global_position
	fireball.direction = (player.global_position - spawn_point.global_position).normalized()
	get_tree().current_scene.add_child(fireball)

func take_damage(amount: int) -> void:
	if is_dead or is_hurt:
		return

	current_health -= amount
	print("Boss took ", amount, " damage! Remaining health: ", current_health)

	if current_health <= 0:
		die()
	else:
		is_hurt = true
		animated_sprite.play("hurt")

func die() -> void:
	if is_dead:
		return
	
	is_dead = true
	is_attacking = false
	is_hurt = false
	
	boss.remove_from_group("enemies")
	animated_sprite.play("death")

func on_animation_finished(_target_player: Node2D, _touching_player: bool) -> void:
	if is_hurt:
		is_hurt = false
	if is_attacking:
		is_attacking = false
	if is_dead:
		await get_tree().create_timer(0.5).timeout
		boss.queue_free()
