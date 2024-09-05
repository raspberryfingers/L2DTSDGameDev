extends Node


func _on_continue_button_pressed():
	pass # Replace with function body.


func _on_new_game_button_pressed():
	GameManager.start_game()
	queue_free()


func _on_main_menu_button_pressed():
	pass # Replace with function body.
