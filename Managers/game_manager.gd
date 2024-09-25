extends Node

var main_menu_screen = preload("res://GUI/GUIMenuScenes/main_menu_screen.tscn")
var pause_menu_screen = preload("res://GUI/GUIMenuScenes/escape_menu.tscn")
var settings_menu_screen = preload("res://GUI/GUIMenuScenes/settings_menu.tscn")
var start_menu_screen = preload("res://GUI/GUIMenuScenes/start_menu_screen.tscn")
var level_1 = preload("res://World/Level1/level_one.tscn")

var is_paused = false  # Track if the game is currently paused

func start_game():
	# Start the game by transitioning to the level scene
	await transition_to_scene(level_1.resource_path)

func exit_game(): 
	get_tree().quit() 

func pause_game():
	is_paused = true
	get_tree().paused = true
	# Hide the game scene when pausing
	var game_scene_instance = get_tree().current_scene
	if game_scene_instance:
		game_scene_instance.visible = false  
	var pause_menu_screen_instance = pause_menu_screen.instantiate()
	get_tree().get_root().add_child(pause_menu_screen_instance)

func resume_game():
	is_paused = false
	get_tree().paused = false
	# Show the game scene when resuming
	var game_scene_instance = get_tree().current_scene
	if game_scene_instance:
		game_scene_instance.visible = true  
	remove_menu_screen()  # Optionally remove the pause menu

func main_menu():
	if is_paused:
		return  # Do not allow main menu if the game is paused
	var main_menu_screen_instance = main_menu_screen.instantiate()
	get_tree().get_root().add_child(main_menu_screen_instance)

func start_menu():
	if is_paused:
		return  # Do not allow start menu if the game is paused
	var start_menu_screen_instance = start_menu_screen.instantiate()
	get_tree().get_root().add_child(start_menu_screen_instance)

func settings_menu(): 
	if is_paused:
		return  # Do not allow settings menu if the game is paused
	var settings_menu_screen_instance = settings_menu_screen.instantiate() 
	get_tree().get_root().add_child(settings_menu_screen_instance)

func transition_to_scene(scene_path):
	print("Transitioning to scene: ", scene_path)
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_file(scene_path)

# Function to remove any active menu screens
func remove_menu_screen():
	for child in get_tree().get_root().get_children():
		if child.is_in_group("menu"):  # Assuming your menus are in a "menu" group
			child.queue_free()
