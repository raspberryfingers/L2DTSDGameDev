extends CanvasLayer

@onready var reward_label = $HBoxContainer3/HBoxContainer/RewardLabel
@onready var time_label = $HBoxContainer3/HBoxContainer2/TimeLabel

func _ready():
	# Check if labels are assigned correctly
	if reward_label == null:
		print("Error: reward_label is null")
	if time_label == null:
		print("Error: time_label is null")

	update_labels(GameManager.game_data.total_reward, GameManager.game_data.elapsed_time)

# Function to update the labels with reward and time
func update_labels(total_reward: int, elapsed_time: float):
	reward_label.text = ": " + str(total_reward)
	
	# Calculate minutes and seconds from elapsed_time
	var seconds = int(elapsed_time) % 60
	var milliseconds = int((elapsed_time - seconds) * 1000)
	
	# Format the time as SS:MMM (seconds:milliseconds)
	time_label.text = ": %02d:%03d" % [seconds, milliseconds]

func _on_quit_game_button_pressed():
	GameManager.exit_game()
	queue_free()
