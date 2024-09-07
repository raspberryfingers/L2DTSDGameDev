extends NodeState

var bullet = preload("res://World/Enemies/EnemyBullet.tscn")

@export var character_body_2d : CharacterBody2D
@export var animated_sprite_2d : AnimatedSprite2D
@export var muzzle : Marker2D
@export var shoot_timer : Timer 

var player : CharacterBody2D
var has_shot : bool = false  # Track whether the turret has shot once

# Called every frame, can be used for non-physics related updates.
func on_process(delta : float):
	pass
	 
# Called every physics frame, used for physics-related updates.
func on_physics_process(delta : float):
	if player and not has_shot:
		shoot_bullet()
		has_shot = true
		shoot_timer.start(2)  # Start the timer for the next shot


func shoot_bullet():
	var direction : int 
	
	# Determine the direction based on the player's position
	if character_body_2d.global_position.x > player.global_position.x:
		animated_sprite_2d.flip_h = false 
		direction = -1 
	else:
		animated_sprite_2d.flip_h = true 
		direction = 1
		
	# Play attack animation
	animated_sprite_2d.play("attack")
	
	# Instantiate and configure the bullet
	var bullet_instance = bullet.instantiate() as Node2D
	bullet_instance.direction = direction 
	bullet_instance.global_position = muzzle.global_position
	get_parent().add_child(bullet_instance)
	
	print("Turret shot a bullet at the player.")

# Set what the player is by getting the node from the "Player" group
func enter(): 
	player = get_tree().get_nodes_in_group("Player")[0] as CharacterBody2D 
	
	# Ensure the turret starts shooting immediately upon entering the state
	has_shot = false  # Reset the shooting flag

func exit(): 
	shoot_timer.stop()


func _on_shoot_timer_timeout():
	shoot_bullet()
	shoot_timer.start(2)
