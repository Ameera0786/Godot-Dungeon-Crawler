extends CanvasLayer

@onready var death_menu: CanvasLayer = $"."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	death_menu.visible = false 

# Death menu 
func show_menu() -> void:
	print("DEATH MENU SHOWING")
	death_menu.visible = true

# Try again
func _on_try_again_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

# Main menu
func _on_main_menu_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/UI/MainMenu.tscn")
