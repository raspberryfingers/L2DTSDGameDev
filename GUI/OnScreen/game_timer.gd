extends Node

var elapsed_time: float = 0.0
var is_running: bool = false

# Called every frame
func _process(delta):
	if is_running:
		elapsed_time += delta  # Increment elapsed time by the frame time

# Start the timer
func start_timer():
	is_running = true

# Stop the timer
func stop_timer():
	is_running = false

# Reset the timer
func reset_timer():
	elapsed_time = 0.0
	is_running = false
