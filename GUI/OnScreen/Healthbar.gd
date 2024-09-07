extends Node2D

@export var full : Texture2D
@export var three_quaters : Texture2D
@export var half : Texture2D
@export var quater : Texture2D
@export var empty : Texture2D 

@onready var health_bar : Sprite2D = $Bar

# Called when the node enters the scene tree for the first time.
func _ready():
	HealthManager.on_health_changed.connect(on_player_health_changed)

func on_player_health_changed(player_current_health : int):
	if player_current_health > 6: 
		health_bar.texture = full
	elif player_current_health == 6 or player_current_health > 4:
		health_bar.texture = three_quaters
	elif player_current_health == 4 or player_current_health > 2:
		health_bar.texture = half
	elif player_current_health == 2 or player_current_health == 1:
		health_bar.texture = quater
	elif player_current_health < 1:
		health_bar.texture = empty
		print("player is dead") 
	

