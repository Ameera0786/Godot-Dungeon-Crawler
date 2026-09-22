class_name PlayerCombat
extends Node2D

# Actions
const ACTIONS = {
	"attack1": "attack1",
	"attack2": "attack2",
	"block": "block"
}

# Export variables
@export_group("Combat")
@export var max_health := 100
@export var attack_1_damage := 45
@export var attack_2_damage := 30

# Player
@onready var player: CharacterBody2D = get_parent()
@onready var sprite: AnimatedSprite2D = $"../AnimatedSprite2D"

# Hitboxes
@onready var attack_1_hit_box: Area2D = $"../HitBoxes/Attack1HitBox"
@onready var attack_2_hit_box: Area2D = $"../HitBoxes/Attack2HitBox"

# Collisions
@onready var attack_1_collision: CollisionShape2D = $"../HitBoxes/Attack1HitBox/CollisionShape2D"
@onready var attack_2_collision: CollisionShape2D = $"../HitBoxes/Attack2HitBox/CollisionShape2D"
@onready var block_collision: CollisionShape2D = $"../HitBoxes/BlockArea/CollisionShape2D"

# Variables
var attacks: Array[AttackData] = []
var health: int
var is_busy := false
var is_blocking := false
var is_dead := false

# Initial load in
func _ready() -> void:
	health = max_health
	HUD.update_health(health, max_health)
	
	attacks = [
		AttackData.new("attack1", attack_1_hit_box, attack_1_collision, [4, 5], attack_1_damage),
		AttackData.new("attack2", attack_2_hit_box, attack_2_collision, [3, 4], attack_2_damage),
	]

	for attack in attacks:
		attack.collision.disabled = true
		attack.hit_box.body_entered.connect(_on_attack_hit_box_body_entered.bind(attack))

	block_collision.disabled = true

# Disable frames as needed
func _process(_delta: float) -> void:
	if is_dead:
		return

	# Handle attack active collision frames
	for attack in attacks:
		attack.collision.disabled = not (sprite.animation == attack.animation and sprite.frame in attack.active_frames)

	# Handle block active collision frames
	var blocking_active = sprite.animation == "block" and sprite.frame in [2, 3, 4, 5]
	block_collision.disabled = not blocking_active
	is_blocking = blocking_active

# Action pressed
func handle_combat_actions() -> bool:
	if is_dead:
		return false

	for action in ACTIONS:
		if Input.is_action_just_pressed(action):
			start_action(ACTIONS[action])
			return true
	return false

# Start action
func start_action(animation_name: String) -> void:
	is_busy = true
	sprite.play(animation_name)

# Animation finished
func on_animation_finished(anim_name: String) -> void:
	if anim_name in ACTIONS.values() or anim_name == "hurt":
		is_busy = false
	elif anim_name == "death":
		player.queue_free()

# Player close enough to enemy 
func _on_attack_hit_box_body_entered(body: Node2D, attack: AttackData) -> void:
	if body.is_in_group("enemy") and body.has_method("take_damage"):
		body.take_damage(attack.damage)

# Player takes damage
func take_damage(amount: int) -> void:
	if is_dead or is_blocking:
		return 
	
	health -= amount
	HUD.update_health(health, max_health)

	print("Player health: ", health, " / ", max_health)
	
	if health <= 0:
		die()
	else:
		is_busy = true
		sprite.play("hurt")

# Player dies
func die() -> void:
	is_dead = true
	player.velocity = Vector2.ZERO
	for attack in attacks:
		attack.collision.disabled = true
	block_collision.disabled = true
	sprite.play("death")
