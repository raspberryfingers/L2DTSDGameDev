extends Control

@onready var animated_sprite_2d = $AnimatedSprite2D 

# Called when the node enters the scene tree for the first time.
func _ready():
	animated_sprite_2d.play("run")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_next_pressed():
	pass



