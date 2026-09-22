extends CharacterBody2D

@export var npc_name: String = "Twisted Sorcerer"
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

@onready var prompt_sprite: AnimatedSprite2D = $AnimatedSprite2D2

func _ready() -> void:
	add_to_group("interactable")
	# Explicitly hide the prompt when the scene loads
	show_prompt(false)

func show_prompt(visible_state: bool) -> void:
	if prompt_sprite:
		prompt_sprite.visible = visible_state

func interact() -> void:
	if DialogueManager.is_active:
		return
		
	DialogueManager.start_dialogue(dialogue_lines, npc_name)
