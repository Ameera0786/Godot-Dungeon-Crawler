extends CharacterBody2D

# Exports
@export var npc_name: String = "Twisted Sorcerer"
@export var ends_game: bool = false
@export_multiline var dialogue_lines: Array[String] = [
	"Greetings traveler! I see another one of you decided to come down and explore the caves.",
	"Beware of the monsters lurking in these halls. I already told the last lot of you that the pathway wasn't worth the treasure",
	"But noooooooooooooooooooooooooooooooooooooooooooooooooooooooo, none of you wanna listen",
	"Anywho. What brings you around?",
	"..........",
	"Oh... Did you think I was gonna let you answer. Um no",
	"...",
	"Anyways.. If you must go on, enter any of those gates right through there. There are many paths to take, and many die on the way.",
	"But hey, if you think you got it, by all means, be my guest. Just keep me out of it.",
	"You likely will need a weapon though. A hammer or axe or gun... OH, you have one, perfect.",
	"Well then, good luck. Now out of my sight.",
	"...."
]

# End screen
@export_file("*.tscn") var end_screen_path: String = "res://scenes/UI/EndScreen.tscn"
@export var fade_duration: float = 3.5

# Sprite
@onready var prompt_sprite: AnimatedSprite2D = $AnimatedSprite2D2

# Initial load in
func _ready() -> void:
	add_to_group("interactable")
	show_prompt(false)

# Show prompt
func show_prompt(visible_state: bool) -> void:
	prompt_sprite.visible = visible_state

# Interact with player
func interact() -> void:
	if DialogueManager.is_active:
		return
	
	DialogueManager.start_dialogue(dialogue_lines, npc_name)
	
	if ends_game:
		end_game()

# Fade in end scene
func end_game() -> void:
	var canvas_layer = CanvasLayer.new()
	var fade_rect = ColorRect.new()
	
	fade_rect.color = Color(0, 0, 0, 0)
	fade_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	
	canvas_layer.add_child(fade_rect)
	get_tree().root.add_child(canvas_layer)
	
	var tween = create_tween()
	tween.tween_property(fade_rect, "color:a", 1.0, fade_duration)
		
	tween.tween_callback(func():
		get_tree().change_scene_to_file(end_screen_path)
		canvas_layer.queue_free()
	)
