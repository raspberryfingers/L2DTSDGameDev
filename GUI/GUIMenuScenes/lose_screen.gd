extends CanvasLayer


func _on_yes_button_pressed():
	GameManager.start_game()
	queue_free()


func _on_no_button_pressed():
	GameManager.main_menu()
	queue_free()
