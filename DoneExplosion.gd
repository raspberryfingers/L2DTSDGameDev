extends Node2D

@export var timer : Timer 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_explosion_area_2d_body_entered(_body):
	timer.start(1.0)

func _on_timer_timeout():
	queue_free()



