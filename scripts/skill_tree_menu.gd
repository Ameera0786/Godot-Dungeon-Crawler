extends CanvasLayer

signal closed

@onready var close_button: Button = %CloseButton
@onready var souls_count_label: Label = $SoulContainer/SoulsCount

# Initial
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS 
	visible = false
	
	update_souls_display()
	PlayerStats.changed.connect(update_souls_display)
	
	close_button.pressed.connect(close)
	
# Open menu
func open() -> void:
	visible = true

# Close menu
func close() -> void:
	visible = false
	closed.emit()

# Update label
func update_souls_display() -> void:
	if souls_count_label:
		souls_count_label.text = "Souls: %d" % PlayerStats.souls
