extends Node2D

@onready var scene_timer = $Timer


# Called when the node enters the scene tree for the first time.
func _ready():
	scene_timer.start(2)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	queue_free()
	GameManager.lose_game() 
