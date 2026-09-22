class_name AttackData
extends RefCounted

var animation: String
var hit_box: Area2D
var collision: CollisionShape2D
var active_frames: Array[int]
var damage: int

func _init(p_animation: String, p_hit_box: Area2D, p_collision: CollisionShape2D,
		p_active_frames: Array[int], p_damage: int) -> void:
	animation = p_animation
	hit_box = p_hit_box
	collision = p_collision
	active_frames = p_active_frames
	damage = p_damage
