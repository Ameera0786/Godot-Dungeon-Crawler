extends Area2D

@onready var lock_room: StaticBody2D = $LockRoom
@export var enemy_group_name: String = "enemies"

var is_locked: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	set_barrier_locked(false)
	
	await get_tree().process_frame
	check_initial_overlap()

func check_initial_overlap() -> void:
	for body in get_overlapping_bodies():
		if body.is_in_group("player"):
			try_lock_room()
			break

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		try_lock_room()

func try_lock_room() -> void:
	if not is_locked:
		var enemies_in_this_room = count_enemies_in_room()
		if enemies_in_this_room > 0:
			set_barrier_locked(true)

func _process(_delta: float) -> void:
	if is_locked:
		var enemies_in_this_room = count_enemies_in_room()
		if enemies_in_this_room == 0:
			print("All enemies in this room defeated! Unlocking barrier.")
			set_barrier_locked(false)

func count_enemies_in_room() -> int:
	var count: int = 0
	for body in get_overlapping_bodies():
		if body.is_in_group(enemy_group_name):
			count += 1
	return count

func set_barrier_locked(locked: bool) -> void:
	is_locked = locked
	for child in lock_room.get_children():
		if child is CollisionPolygon2D:
			child.set_deferred("disabled", not locked)
