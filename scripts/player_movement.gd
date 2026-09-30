extends CharacterBody2D

# Player
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitboxes: Node2D = $HitBoxes
@onready var combat: PlayerCombat = $Combat
@onready var interaction_area: Area2D = $InteractionArea

# Variables
@export var speed = 110.0
var current_interactable: Node2D = null

# Initial load in
func _ready() -> void:
	add_to_group("player")
	sprite.animation_finished.connect(_on_animation_finished)

	interaction_area.area_entered.connect(_on_interaction_area_entered)
	interaction_area.area_exited.connect(_on_interaction_area_exited)
	interaction_area.body_entered.connect(_on_interaction_body_entered)
	interaction_area.body_exited.connect(_on_interaction_body_exited)

# Handle actions and movement
func _physics_process(_delta: float) -> void:
	if combat.is_dead:
		return

	if not combat.handle_combat_actions():
		handle_interaction_input()

	handle_movement()
	move_and_slide()

# Flip character based on direction and move animations
func handle_movement() -> void:
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed

	if direction.x < 0:
		sprite.flip_h = true
		hitboxes.scale.x = -1
	elif direction.x > 0:
		sprite.flip_h = false
		hitboxes.scale.x = 1

	if not combat.is_busy:
		if direction != Vector2.ZERO:
			sprite.play("walk")
		else:
			sprite.play("idle")

# Interaction input
func handle_interaction_input() -> void:
	if Input.is_action_just_pressed("interact"):
		interact()

# Interact with current target
func interact() -> void:
	if current_interactable and current_interactable.has_method("interact"):
		current_interactable.interact()

# Interaction area entered
func _on_interaction_area_entered(area: Area2D) -> void:
	_check_and_set_interactable(area)

# Interaction body entered
func _on_interaction_body_entered(body: Node2D) -> void:
	_check_and_set_interactable(body)

# Interaction area exited
func _on_interaction_area_exited(area: Area2D) -> void:
	_check_and_clear_interactable(area)

# Interation body exited
func _on_interaction_body_exited(body: Node2D) -> void:
	_check_and_clear_interactable(body)

# Check if target is interactable
func _check_and_set_interactable(target: Node2D) -> void:
	var candidate = target
	if not candidate.is_in_group("interactable") and candidate.get_parent():
		candidate = candidate.get_parent()

	if candidate.is_in_group("interactable"):
		current_interactable = candidate
		
		if current_interactable.has_method("show_prompt"):
			current_interactable.show_prompt(true)

func _check_and_clear_interactable(target: Node2D) -> void:
	var candidate = target
	if current_interactable == candidate or (candidate.get_parent() and current_interactable == candidate.get_parent()):
		if current_interactable.has_method("show_prompt"):
			current_interactable.show_prompt(false)
		
		if DialogueManager.is_active:
			DialogueManager.close_dialogue()
			
		current_interactable = null
		
# Direct external damage calls to the combat node
func take_damage(amount: int) -> void:
	combat.take_damage(amount)

# Animation finished
func _on_animation_finished() -> void:
	combat.on_animation_finished(sprite.animation)
