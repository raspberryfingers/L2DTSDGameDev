extends Area2D

# Define groups for the ladders
var ladder_groups = ["Ladders"]

# Called when the node enters the scene tree for the first time.
func _ready():
	# Add this ladder to the "Ladders" group
	for group in ladder_groups:
		add_to_group(group)

# Detect when the player enters the ladder area
func _on_body_entered(body):
	if body.is_in_group("Player"):
		body.on_ladder = true


# Detect when the player exits the ladder area
func _on_body_exited(body):
	if body.is_in_group("Player"):
		body.on_ladder = false
