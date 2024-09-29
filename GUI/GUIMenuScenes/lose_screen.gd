extends CanvasLayer


func _on_quit_game_button_pressed():
	GameManager.exit_game() 
	queue_free()
