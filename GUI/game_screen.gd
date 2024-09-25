extends CanvasLayer

@onready var collectable_label = $MarginContainer/VBoxContainer/HBoxContainer/Control/CollectableLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	CollectableManager.on_collectable_award_recieved.connect(on_collectable_award_recieved)

func _input(event):
	if event.is_action_pressed("pause"):
		toggle_pause()

func on_collectable_award_recieved(total_award : int): 
	collectable_label.text = str(total_award)

# Toggle the pause state and handle visibility
func toggle_pause():
	if GameManager.is_paused:  # Check if the game is already paused
		GameManager.resume_game()  # Resume the game
		collectable_label.visible = true  # Show the UI when resuming
	else:
		GameManager.pause_game()  # Pause the game
		collectable_label.visible = false  # Hide the UI when paused
