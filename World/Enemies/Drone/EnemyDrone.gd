extends CharacterBody2D

# Preload effects for enemy death and attack
var enemy_death_effect = preload("res://World/Enemies/EnemyDeath/enemy_explosion_node_2d.tscn")
var enemy_attack_effect = preload("res://World/Enemies/Drone/DroneAttack/drone_explosion_attack.tscn")

# Node references
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var patrol_points: Node = $PatrolPoints
@onready var wait_timer: Timer = $WaitTimer
@onready var attack_timer: Timer = $AttackTimer
@onready var hurtbox: Area2D = $HurtBoxArea2D
@onready var attack_area: Area2D = $AttackArea2D
@onready var animation_player = $AnimationPlayer

# Enemy properties
@export var health_amount: int = 3  
@export var damage_amount: int = 0
@export var speed: float = 750 
@export var chase_speed: float = 1500
@export var wait_time: int = 3 
@export var explosion_delay: float = 6.9  # Time before the drone explodes when chasing

# Finite State Machine (FSM) for the enemy behavior
enum State { Idle, Walk, Chase, Explode, Frozen }

# Variables for movement and patrol points
var current_state: State = State.Walk  # Start in Walk state for patrol
var direction: Vector2 = Vector2.LEFT 
var number_of_points: int = 0
var point_positions: Array[Vector2] = []
var current_point_position: int = 0
var can_walk: bool = true
var current_point: Vector2

# Declare the player variable here
var player: Node2D = null  # Declare the player variable at the class level

# Called when the node is ready
func _ready():
	# Populate patrol points if available
	if patrol_points != null:
		number_of_points = patrol_points.get_child_count()
		for point in patrol_points.get_children():
			point_positions.append(point.global_position)
		if point_positions.size() > 0:
			current_point = point_positions[current_point_position]
		else:
			print("Patrol points are empty")
	else: 
		print("No patrol points")

	wait_timer.wait_time = wait_time  # Set wait time for patrol

# Called every physics frame
func _physics_process(delta: float):
	# Debug print current state and player presence
	print("Current State: ", current_state, " Player Exists: ", player != null)

	# Run different states based on current logic
	match current_state:
		State.Idle: enemy_idle(delta)
		State.Walk: enemy_walk(delta)
		State.Chase: enemy_chase(delta)
		State.Frozen: enemy_frozen(delta)

	move_and_slide()  # Apply movement
	enemy_animations()  # Play appropriate animations

# Handles the idle state of the enemy
func enemy_idle(delta: float):
	if not can_walk:  # Enemy is idle if it cannot walk
		velocity.x = move_toward(velocity.x, 0, speed * delta)  # Slow down

# Handles the walking state of the enemy
func enemy_walk(delta: float):
	if not can_walk or current_point == null:
		return 

	# If in Chase state, do not transition to Idle or Walk
	if current_state == State.Chase:
		return

	# If not at patrol point, move towards it
	if abs(position.x - current_point.x) > 0.5:
		velocity.x = direction.x * speed * delta

		# Flip sprite based on direction
		animated_sprite_2d.flip_h = direction.x > 0
	else:
		# If reached the patrol point and is not chasing, stop and wait
		can_walk = false  # Stop walking
		wait_timer.start()  # Start wait timer at patrol point
		print("Reached patrol point, waiting for 3 seconds...")
		current_state = State.Idle  # Change to Idle state to indicate waiting

# Handles the chase state where the enemy pursues the player
func enemy_chase(delta: float):
	if player != null:
		# Move towards the player
		direction = (player.global_position - global_position).normalized()
		velocity = direction * chase_speed * delta

		# Flip sprite to face the player
		animated_sprite_2d.flip_h = direction.x > 0  # Flip based on direction
		print("Chasing player")
	else:
		# If player is lost
		velocity = Vector2.ZERO
		current_state = State.Frozen  # Freeze if player is lost

# Handles the frozen state where the enemy stops moving
func enemy_frozen(delta: float):
	velocity = Vector2.ZERO  # Stop the enemy's movement

# Handles the explosion of the enemy
func explode():
	var enemy_attack_effect_instance = enemy_attack_effect.instantiate() as Node2D
	enemy_attack_effect_instance.global_position = global_position
	get_parent().add_child(enemy_attack_effect_instance)  # Add explosion effect to the scene
	queue_free()  # Remove the enemy from the scene
	
func enemy_death(): 
	var enemy_death_effect_instance = enemy_death_effect.instantiate() as Node2D
	enemy_death_effect_instance.global_position = global_position
	get_parent().add_child(enemy_death_effect_instance)
	queue_free()
	print("Enemy died, death effect played")

# Triggered when something enters the hurtbox area (used for taking damage)
func _on_hurt_box_area_2d_area_entered(area):
	if area.get_parent().has_method("get_damage_amount"):
		var node = area.get_parent() as Node
		health_amount -= node.damage_amount  # Reduce health based on incoming damage
		
		# If health is zero or below, trigger death
		if health_amount <= 0:
			enemy_death()

# Triggered when the player enters the attack area
func _on_attack_area_2d_body_entered(body: Node2D):
	if body.is_in_group("Player"):
		player = body  # Set player as the target
		wait_timer.stop()
		current_state = State.Chase
		attack_timer.start(explosion_delay)  # Start the attack timer
		animation_player.play("detinate")  # Play detonate animation
		print("Player detected, starting attack timer")

# Triggered when the player exits the attack area
func _on_attack_area_2d_body_exited(body: Node2D):
	if body.is_in_group("Player"):
		player = null  # Clear the player reference
		current_state = State.Frozen  # Freeze the enemy
		print("Player exited, enemy frozen but will still explode")

# Plays animations based on the current state
func enemy_animations():
	match current_state:
		State.Idle:
			animated_sprite_2d.play("fly") 
		State.Walk:
			animated_sprite_2d.play("fly")
		State.Frozen:
			animated_sprite_2d.play("fly")

# Triggered when the wait timer times out (after reaching a patrol point)
func _on_wait_timer_timeout():
	can_walk = true  # Allow the enemy to walk again
	current_point_position += 1  # Move to the next patrol point
		
	# Reset patrol point index if exceeded
	if current_point_position >= number_of_points:
		current_point_position = 0 
		
	current_point = point_positions[current_point_position]
	# Set direction towards next patrol point
	direction = (current_point - position).normalized()
		 
	# Transition to Walk state
	current_state = State.Walk
	print("Moving to the next patrol point.")

# Triggered when the attack timer times out (initiates explosion)
func _on_attack_timer_timeout():
	explode()  # Call the explosion function
