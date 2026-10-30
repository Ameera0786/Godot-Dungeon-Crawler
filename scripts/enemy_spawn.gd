extends Node2D

var enemy_scenes = [
	preload("res://scenes/players/Enemy_blood_monster.tscn"),
	preload("res://scenes/players/Enemy_orc.tscn"),
	preload("res://scenes/players/Enemy_slime.tscn"),
	preload("res://scenes/players/Enemy_mage.tscn")
]

@export var min_enemies = 2
@export var max_enemies = 4

# Initial load in
func _ready():
	spawn_enemies()

# Spawn enemies in random spots
func spawn_enemies():
	var spawn_points = get_children()
	spawn_points.shuffle()

	var enemy_count = randi_range(min_enemies, max_enemies)
	enemy_count = min(enemy_count, spawn_points.size())

	for i in range(enemy_count):
		var enemy_scene = enemy_scenes.pick_random()
		var enemy = enemy_scene.instantiate()

		add_enemy.call_deferred(enemy, spawn_points[i].global_position)

# Add a new enemy to the location
func add_enemy(enemy: Node2D, spawn_position: Vector2):
	var room = get_parent()
	room.add_child(enemy)
	enemy.global_position = spawn_position
