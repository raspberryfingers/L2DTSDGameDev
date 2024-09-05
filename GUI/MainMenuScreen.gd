extends CanvasLayer


func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://StartMenu/start_menu_screen.tscn")


func _on_quit_button_pressed():
	GameManager.exit_game()
