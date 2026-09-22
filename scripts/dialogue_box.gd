extends CanvasLayer

@onready var panel: Panel = $Panel
@onready var title_label: Label = $Panel/Panel/Title
@onready var text_label: Label = $Panel/Text

var current_lines: Array[String] = []
var line_index := 0
var is_active := false

func _ready() -> void:
	panel.visible = false

func start_dialogue(lines: Array[String], speaker_name: String = "") -> void:
	if lines.is_empty():
		return

	current_lines = lines
	line_index = 0
	is_active = true
	panel.visible = true
	title_label.text = speaker_name
	show_line()

func show_line() -> void:
	text_label.text = current_lines[line_index]

func advance_dialogue() -> void:
	line_index += 1
	if line_index < current_lines.size():
		show_line()
	else:
		end_dialogue()

func end_dialogue() -> void:
	is_active = false
	panel.visible = false

# Call this from outside if the player walks away mid-dialogue
func close_dialogue() -> void:
	if is_active:
		end_dialogue()

func _unhandled_input(event: InputEvent) -> void:
	if is_active and event.is_action_pressed("interact") and not event.is_echo():
		get_viewport().set_input_as_handled()
		advance_dialogue()
