extends Area2D


func _on_body_entered(body):
	if body.is_in_group("Player"):  # Assuming your player is in a group named "Player"
		var total_reward = CollectableManager.total_award_amount
		var elapsed_time = GameTimer.elapsed_time  # Access the elapsed time from the singleton
		GameManager.win_game()  # Call the win_game function in GameManager
