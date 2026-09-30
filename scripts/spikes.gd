extends TileMapLayer

# Exports
@export var damage_amount := 5
@export var damage_radius := 20.0
@export var damage_cooldown := 1.5

var can_damage := true

# Checks every frame if player is on spike, if so, damage
func _process(delta): 
	if not can_damage:
		return
		
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return
	
	for cell in get_used_cells():
		var tile_data = get_cell_tile_data(cell)
		var spike = to_global(map_to_local(cell))
		
		if player.global_position.distance_to(spike) <= damage_radius:
			player.take_damage(damage_amount)
			can_damage = false
			await get_tree().create_timer(damage_cooldown).timeout
			can_damage = true
