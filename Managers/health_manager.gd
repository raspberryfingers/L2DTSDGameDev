extends Node

var player_death_effect = preload("res://Player/PlayerDeath/player_death_effect.tscn")

var max_health : int = 8  
var current_health : int 

signal on_health_changed 

# Called when the node enters the scene tree for the first time.
func _ready():
	current_health = max_health 
	
func decrease_health(health_amount : int): 
	current_health -= health_amount
	
	if current_health < 0: 
		current_health = 0 
		
	print("decrease health called")
	on_health_changed.emit(current_health) 
		
func increase_health(health_amount : int): 
	current_health += health_amount
	
	if current_health > max_health: 
		current_health = max_health
		
	print("increase health called")
	on_health_changed.emit(current_health) 


