extends Node

# Preload menu screens and level
var main_menu_screen = preload("res://GUI/GUIMenuScenes/main_menu_screen.tscn")
var pause_menu_screen = preload("res://GUI/GUIMenuScenes/escape_menu.tscn")
var settings_menu_screen = preload("res://GUI/GUIMenuScenes/settings_menu.tscn")
var start_menu_screen = preload("res://GUI/GUIMenuScenes/start_menu_screen.tscn")
var lose_screen = preload("res://GUI/GUIMenuScenes/lose_screen.tscn")
var win_screen = preload("res://GUI/GUIMenuScenes/win_screen.tscn")
var level_1 = preload("res://World/Level1/level_one.tscn")

var is_paused = false  # Track if the game is currently paused

# Called when the node is added to the scene.
# Load settings when the game starts.
func _ready():
	SettingsManager.load_settings()

# Starts the game by transitioning to the first level.
func start_game():
	await transition_to_scene(level_1.resource_path)
	get_tree().paused = false  # Ensure the game is unpaused

# Quits the game entirely.
func exit_game(): 
	get_tree().quit()

# Pauses the game and shows the pause menu.
func pause_game():   
	is_paused = true
	get_tree().paused = true  # Pause the game logic
	var game_scene_instance = get_tree().current_scene  # Get the current game scene
	if game_scene_instance:
		game_scene_instance.visible = false  # Hide the game scene while paused
	show_menu_screen(pause_menu_screen)  # Show the pause menu

# Resumes the game and removes the pause menu.
func resume_game():
	is_paused = false
	get_tree().paused = false  # Unpause the game
	var game_scene_instance = get_tree().current_scene
	if game_scene_instance:
		game_scene_instance.visible = true  # Show the game scene again
	remove_menu_screen()  # Remove any active menu screens

# Displays the main menu screen.
func main_menu():
	show_menu_screen(main_menu_screen)

# Displays the start menu screen.
func start_menu():
	show_menu_screen(start_menu_screen)

# Displays the settings menu screen.
func settings_menu(): 
	show_menu_screen(settings_menu_screen)

# Displays the lose screen when the player loses the game.
func lose_game(): 
	show_menu_screen(lose_screen)
	
func win_game():
	show_menu_screen(win_screen)

# Transition to a new scene after a short delay (useful for smooth transitions).
func transition_to_scene(scene_path):
	print("Transitioning to scene: ", scene_path)
	await get_tree().create_timer(0.1).timeout  # Add a slight delay before switching scenes
	get_tree().change_scene_to_file(scene_path)  # Change to the specified scene

# Utility function to instantiate and show any menu screen passed as a parameter.
# This reduces redundant code for each menu screen.
func show_menu_screen(menu_scene):
	var menu_instance = menu_scene.instantiate()  # Create an instance of the menu scene
	get_tree().get_root().add_child(menu_instance)  # Add the instance to the root of the scene tree

# Removes all active menu screens from the root node.
# This assumes that menu screens are added to a "menu" group.
func remove_menu_screen():
	for child in get_tree().get_root().get_children():
		if child.is_in_group("menu"):  # If the child is part of the "menu" group
			child.queue_free()  # Remove the menu from the scene tree
