extends CanvasLayer

@onready var collectable_label = $MarginContainer/VBoxContainer/HBoxContainer/Control/CollectableLabel
@onready var timer_label = $TimerLabel

var elapsed_time: float = 0.0  # To keep track of the elapsed time
var is_timer_running: bool = false  # To control timer state


# Called when the node enters the scene tree for the first time.
func _ready():
	CollectableManager.on_collectable_award_recieved.connect(on_collectable_award_recieved)
	GameManager.game_resumed.connect(_on_game_resumed)
	start_timer()  # Start the timer as soon as the level is entered
	
func _on_game_resumed():
	start_timer()  # Resume the timer when the game is resumed

func _input(event):
	if event.is_action_pressed("pause"):
		if is_timer_running:
			pause_timer()  
		GameManager.pause_game()

func on_collectable_award_recieved(total_award: int):
	collectable_label.text = str(total_award)

# Function to start the timer
func start_timer():
	if not is_timer_running:  # Only start if it's not already running
		is_timer_running = true
		print("Starting timer")

# Function to pause the timer
func pause_timer():
	if is_timer_running:
		is_timer_running = false
		print("Pausing timer")

# Called every frame to update the timer
func _process(delta):
	if is_timer_running:
		elapsed_time += delta
		
		# Display elapsed time with two decimal places
		timer_label.text = str("%.2f" % elapsed_time)

# Function to stop the timer
func stop_timer():
	is_timer_running = false
	elapsed_time = 0.0
	timer_label.text = "0.00"
