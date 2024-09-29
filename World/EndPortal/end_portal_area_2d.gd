extends Area2D


func _on_body_entered(body):
	if body.is_in_group("Player"):  # Assuming your player is in a group named "Player"
		GameManager.win_game()  # Call the win_game function in GameManager
