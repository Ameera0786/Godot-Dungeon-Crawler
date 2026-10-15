extends Node

signal changed

var souls := 15.0
var progress := {}
var flat := {}
var percent := {}

# Get souls
func add_souls(n: float) -> void:
	souls += n
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
	
	changed.emit()
	return true

# Get new stat
func get_stat(stat: StringName, base: float) -> float:
	return (base + flat.get(stat, 0.0)) * (1.0 + percent.get(stat, 0.0) / 100.0)
