extends Area2D

# Array of possible destination rooms (Assign scene files in the Inspector)
@export_file("*.tscn") var target_scenes: Array[String] = []

# Fallback or specific room path if you prefer a single target
@export_file("*.tscn") var single_target_scene: String = ""

# Enable this in the Inspector to randomize room choice for this door
@export var use_random_room: bool = true

# Name of the spawn marker node in the target room
@export var target_spawn_name: String = "PlayerSpawn"

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return

	# Check if any enemies are still alive in the current room
	var alive_enemies = get_tree().get_nodes_in_group("enemy")
	if alive_enemies.size() > 0:
		print("Door locked! Defeat all enemies to proceed.")
		return

	var chosen_scene: String = ""

	# Pick scene based on settings
	if use_random_room and target_scenes.size() > 0:
		chosen_scene = target_scenes.pick_random()
	elif single_target_scene != "":
		chosen_scene = single_target_scene

	# Transition to room if valid
	if chosen_scene != "":
		Global.target_spawn_name = target_spawn_name
		get_tree().change_scene_to_file(chosen_scene)
	else:
		print("This door is decorative or has no destination assigned.")
