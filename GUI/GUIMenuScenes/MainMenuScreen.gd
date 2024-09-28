extends CanvasLayer


func _on_start_button_pressed():
	GameManager.start_menu()
	queue_free()


func _on_quit_button_pressed():
	GameManager.exit_game()
	queue_free()


func _on_settings_button_pressed():
	GameManager.settings_menu()
	queue_free()
