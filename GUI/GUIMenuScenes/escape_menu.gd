extends CanvasLayer


func _on_resume_button_pressed():
	GameManager.resume_game()
	queue_free()


func _on_main_menu_button_pressed():
	GameManager.main_menu()
	queue_free()


func _on_restart_button_pressed():
	GameManager.start_game()
	queue_free()


func _on_quit_game_button_pressed():
	GameManager.exit_game()
	queue_free()
