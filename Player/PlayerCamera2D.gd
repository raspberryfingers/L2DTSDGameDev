extends Camera2D

@export var player : CharacterBody2D 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if player != null: 
		global_position = player.global_position 
