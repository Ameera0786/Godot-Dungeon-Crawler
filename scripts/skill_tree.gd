extends Node2D

@export var skill_node_scene: PackedScene
@export var branches: Array[BranchData]
@export var spacing := 3
@export var skill_size := 64.0

@export var min_zoom := 0.5
@export var max_zoom := 2.5
@export var zoom_step := 1.1
var zoom := 1.0

# Get window size and call to create node
func _ready() -> void:
	position = get_viewport_rect().size / 2.0
	create_skill_nodes()

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

# Zoom
func _input(event: InputEvent) -> void:
	if not is_visible_in_tree():
		return

	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom *= zoom_step
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom /= zoom_step
		else:
			return
	
	zoom = clampf(zoom, min_zoom, max_zoom)
	scale = Vector2.ONE * zoom
