extends Node2D

@export var skill_node_scene: PackedScene
@export var branches: Array[BranchData]
@export var spacing := 3
@export var skill_size := 64.0

@export var min_zoom := 0.4
@export var max_zoom := 2.5
@export var zoom_step := 1.1

var zoom := 1.0
var is_panning := false
var pan_start := Vector2.ZERO
var default_zoom := 1.0
var default_position := Vector2.ZERO

# Get window size and call to create node
func _ready() -> void:
	create_skill_nodes()
	position = get_viewport_rect().size / 2.0
	
	default_zoom = zoom
	default_position = position

# Create nodes
func create_skill_nodes() -> void:
	for branch in branches:
		var dir := Vector2.UP.rotated(deg_to_rad(branch.angle_deg))
		
		for i in branch.skills.size():
			var distance := skill_size * spacing * (i + 1)
			var node_position := dir * distance

			var skill: TextureButton = skill_node_scene.instantiate()
			add_child(skill)
			skill.setup(branch, i)

			skill.size = Vector2(skill_size, skill_size)
			skill.position = node_position - skill.size / 2.0
			skill.z_index = 1

# Zoom and pan
func _input(event: InputEvent) -> void:
	if not is_visible_in_tree():
		return

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			zoom_tree(zoom_step)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			zoom_tree(1.0 / zoom_step)
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			is_panning = event.pressed
			pan_start = get_global_mouse_position()

	elif event is InputEventMouseMotion and is_panning:
		var current_mouse := get_global_mouse_position()
		position += current_mouse - pan_start
		pan_start = current_mouse

# Clamp
func zoom_tree(factor: float) -> void:
	zoom = clampf(zoom * factor, min_zoom, max_zoom)
	scale = Vector2.ONE * zoom

# Reset
func reset_view() -> void:
	zoom = default_zoom
	scale = Vector2.ONE * zoom
	position = default_position
	is_panning = false
