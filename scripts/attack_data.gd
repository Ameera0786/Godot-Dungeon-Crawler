class_name AttackData
extends RefCounted

var animation: String
var hit_box: Area2D
var collision: CollisionShape2D
var active_frames: Array[int]
var damage: int
var sound: AudioStream
var sound_delay: float

# Data class for attacks
func _init(
	animation_name: String,
	attack_hit_box: Area2D,
	attack_collision: CollisionShape2D,
	frames: Array[int],
	attack_damage: int,
	attack_sound: AudioStream,
	delay: float,
) -> void:
	animation = animation_name
	hit_box = attack_hit_box
	collision = attack_collision
	active_frames = frames
	damage = attack_damage
	sound = attack_sound
	sound_delay = delay
