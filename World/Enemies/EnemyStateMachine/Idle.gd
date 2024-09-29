extends NodeState

@export var character_body_2d : CharacterBody2D
@export var animated_sprite_2d : AnimatedSprite2D

func on_process(_delta : float):
	pass
	
func on_physics_process(_delta : float):
	animated_sprite_2d.play("idle")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func enter():
	pass
	
func exit():
	pass
