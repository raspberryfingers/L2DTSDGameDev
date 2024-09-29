extends Node

var game_data: GameDataResource = GameDataResource.new() # Declare the GameData resource

# Preload menu screens and level
var main_menu_screen = preload("res://GUI/GUIMenuScenes/main_menu_screen.tscn")
var pause_menu_screen = preload("res://GUI/GUIMenuScenes/escape_menu.tscn")
var settings_menu_screen = preload("res://GUI/GUIMenuScenes/settings_menu.tscn")
var start_menu_screen = preload("res://GUI/GUIMenuScenes/start_menu_screen.tscn")

var lose_screen = preload("res://GUI/GUIMenuScenes/lose_screen.tscn")
var win_screen = preload("res://GUI/GUIMenuScenes/win_screen.tscn")
var level_1 = preload("res://World/Level1/level_one.tscn")  

var is_paused = false  # Track if the game is currently paused

# Signal to notify when the game is resumed
signal game_resumed

# Called when the node is added to the scene.
func _ready():
	SettingsManager.load_settings()
	show_menu_screen(main_menu_screen)  # Start at the main menu

# Starts the game by transitioning to the first level.
func start_game():
	game_data.total_reward = 0  # Reset total reward when starting a new game
	game_data.elapsed_time = 0.0  # Reset elapsed time
	GameTimer.reset_timer()  # Reset timer when starting a new game
	GameTimer.start_timer()   # Start the timer
	transition_to(level_1)  # Load the level scene directly
	get_tree().paused = false  # Ensure the game is unpaused

# Quits the game entirely.
func exit_game(): 
	get_tree().quit()

# Pauses the game and shows the pause menu.
func pause_game():   
	is_paused = true
	get_tree().paused = true 
	var game_scene_instance = get_tree().current_scene  
	if game_scene_instance:
		game_scene_instance.visible = false 
	show_menu_screen(pause_menu_screen) 

# Resumes the game and removes the pause menu.
func resume_game():
	is_paused = false
	get_tree().paused = false 
	var game_scene_instance = get_tree().current_scene
	if game_scene_instance:
		game_scene_instance.visible = true 
	remove_menu_screen() 

	emit_signal("game_resumed")  

# Displays the lose screen when the player loses the game.
func lose_game(): 
	GameTimer.stop_timer()
	show_menu_screen(lose_screen)

# Displays the win screen and stops the timer
func win_game():
	GameTimer.stop_timer()
	game_data.elapsed_time = GameTimer.elapsed_time  # Assuming you have a method to get the elapsed time from the timer
	game_data.total_reward = CollectableManager.total_award_amount
	show_menu_screen(win_screen)  # Display the win screen

func start_menu():
	show_menu_screen(start_menu_screen)
	
func main_menu(): 
	show_menu_screen(main_menu_screen)
	
func settings_menu():
	show_menu_screen(settings_menu_screen)

# Change to a new scene.
func transition_to(scene: PackedScene):
	print("Changing scene to: ", scene)
	# Clear current scene
	var current_scene = get_tree().current_scene
	if current_scene:
		current_scene.queue_free()  # Remove the current scene
	var new_scene_instance = scene.instantiate()  # Create a new instance of the level
	get_tree().get_root().add_child(new_scene_instance)  # Add the new instance to the root

# Utility function to instantiate and show any menu screen passed as a parameter.
# This reduces redundant code for each menu screen.
func show_menu_screen(menu_scene):
	var menu_instance = menu_scene.instantiate()  # Create an instance of the menu scene
	get_tree().get_root().call_deferred("add_child", menu_instance)

# Removes all active menu screens from the root node.
# This assumes that menu screens are added to a "menu" group.
func remove_menu_screen():
	for child in get_tree().get_root().get_children():
		if child.is_in_group("menu"):  # If the child is part of the "menu" group
			child.queue_free()  # Remove the menu from the scene tree
			

