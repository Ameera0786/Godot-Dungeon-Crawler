extends Node

signal changed

const SAVE_PATH = "user://savegame.json"

var souls := 0.0
var progress := {}
var flat := {}
var percent := {}

# Get souls
func add_souls(n: float) -> void:
	souls += n
	save_game()
	changed.emit()

# Get current progress
func get_progress(branch: BranchData) -> int:
	return progress.get(branch, 0)

# Attempt to purchase
func buy(branch: BranchData, index: int) -> bool:
	if index != get_progress(branch): 
		return false
		
	var s := branch.skills[index]
	if souls < s.cost: 
		return false
	
	souls -= s.cost
	progress[branch] = index + 1
	
	if s.kind == SkillData.Kind.FLAT:
		flat[s.stat] = flat.get(s.stat, 0.0) + s.amount
	else:
		percent[s.stat] = percent.get(s.stat, 0.0) + s.amount
	
	save_game()
	changed.emit()
	return true

# Get new stat
func get_stat(stat: StringName, base: float) -> float:
	return (base + flat.get(stat, 0.0)) * (1.0 + percent.get(stat, 0.0) / 100.0)

# Save stats
func save_game() -> void:
	var saved_progress := {}

	for branch in progress:
		if branch.resource_path != "":
			saved_progress[branch.resource_path] = progress[branch]

	var save_data = {
		"souls": souls,
		"progress": saved_progress
	}

	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)

	if file == null:
		push_error("Could not save game.")
		return

	file.store_string(JSON.stringify(save_data))
	file.close()

# Load game
func load_game() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return

	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		return

	var data = JSON.parse_string(file.get_as_text())
	file.close()

	if typeof(data) != TYPE_DICTIONARY:
		push_error("Save file is invalid.")
		return

	souls = data.get("souls", 0.0)
	progress.clear()

	var saved_progress = data.get("progress", {})

	for path in saved_progress:
		var branch: BranchData = load(path) as BranchData

		if branch != null:
			progress[branch] = int(saved_progress[path])

	_rebuild_bonuses()
	changed.emit()

# Recalculate bonuses from purchased skills
func _rebuild_bonuses() -> void:
	flat.clear()
	percent.clear()

	for branch in progress:
		var purchased_count: int = progress[branch]

		for i in range(mini(purchased_count, branch.skills.size())):
			var s = branch.skills[i]

			if s.kind == SkillData.Kind.FLAT:
				flat[s.stat] = flat.get(s.stat, 0.0) + s.amount
			else:
				percent[s.stat] = percent.get(s.stat, 0.0) + s.amount

# Reset stats
func reset() -> void:
	souls = 0.0
	progress.clear()
	flat.clear()
	percent.clear()
	save_game()
	changed.emit()
