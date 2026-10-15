extends TextureButton

var branch: BranchData
var index: int

@onready var cost_label: Label = $CostLabel

# Set up nodes
func setup(b: BranchData, i: int) -> void:
	branch = b
	index = i
	texture_normal = b.skills[i].icon
	
	if not pressed.is_connected(_on_pressed):
		pressed.connect(_on_pressed)
		
	if not PlayerStats.changed.is_connected(refresh):
		PlayerStats.changed.connect(refresh)
		
	refresh()

# Buy
func _on_pressed() -> void:
	PlayerStats.buy(branch, index)

# Refresh based on status
func refresh() -> void:
	var progress := PlayerStats.get_progress(branch)
	var s := branch.skills[index]
	
	visible = index <= progress + 1
	var sign_str = "+" if s.amount > 0 else ""
	var unit_str = "%" if s.kind == SkillData.Kind.PERCENT else ""
	
	var effect_text = "%s%s%s %s" % [sign_str, s.amount, unit_str, String(s.stat).capitalize()]
	var base_tooltip = "%s\n%s\n\nEffect: %s" % [s.display_name, s.description, effect_text]
	
	# Owned
	if index < progress:
		self_modulate = Color.WHITE
		cost_label.hide()
		tooltip_text = base_tooltip + "\n[Status: Purchased]"
	# Available
	elif index == progress:
		self_modulate = Color.WHITE if PlayerStats.souls >= s.cost else Color(0.7, 0.7, 0.7)
		cost_label.show()
		cost_label.text = str(s.cost)
		tooltip_text = base_tooltip + "\nCost: %d Souls" % s.cost
	# Locked
	else:
		self_modulate = Color(0.25, 0.25, 0.3)
		cost_label.show()
		cost_label.text = "?"
		tooltip_text = "Locked\nComplete previous skills to unlock."
