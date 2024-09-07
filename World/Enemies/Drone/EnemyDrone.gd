extends CharacterBody2D

var enemy_death_effect = preload("res://World/Enemies/EnemyDeath/enemy_explosion_node_2d.tscn")
var enemy_attack_effect = preload("res://World/Enemies/Drone/DroneAttack/drone_explosion_attack.tscn")

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var patrol_points : Node = $PatrolPoints
@onready var timer = $Timer
@onready var hurtbox : Area2D = $HurtBox
@onready var attack_area : Area2D = $AttackArea  # The area that detects the player
@onready var player : Node2D = null


@export var health_amount : int = 3  
@export var speed: float = 750 
@export var wait_time : int = 3 
@export var explosion_delay : float = 3.0  # Time before the drone explodes when chasing

enum State { Idle, Walk, Chase, Explode }

var current_state : State = State.Idle
var direction : Vector2 = Vector2.LEFT 
var number_of_points : int = 0
var point_positions : Array[Vector2] = []
var current_point_position : int = 0
var can_walk : bool = true
var current_point : Vector2

func _ready():
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
		
	timer.wait_time = wait_time
	current_state = State.Idle 
	print("Initial state: Idle")

func _physics_process(delta : float):
	enemy_idle(delta)
	enemy_walk(delta)
	enemy_chase(delta)
	
	move_and_slide()
	enemy_animations()
	
	if is_on_floor(): 
		health_amount = 0

func enemy_idle(delta : float):
	if not can_walk:
		velocity.x = move_toward(velocity.x, 0, speed * delta)
		current_state = State.Idle 
		print("State set to Idle")

func enemy_walk(delta : float):
	if not can_walk or current_point == null:
		return 

	if abs(position.x - current_point.x) > 0.5:
		velocity.x = direction.x * speed * delta
		current_state = State.Walk 
		print("State set to Walk")

		animated_sprite_2d.flip_h = direction.x > 0 
		print("Flipping sprite: ", direction.x > 0)
	else: 
		current_point_position += 1 
		
		if current_point_position >= number_of_points:
			current_point_position = 0 
		
		current_point = point_positions[current_point_position]
	
		if current_point.x > position.x: 
			direction = Vector2.RIGHT
		else: 
			direction = Vector2.LEFT 
			
		can_walk = false 
		timer.start() 
		print("Timer started, current point position: ", current_point_position)

func enemy_chase(delta: float):
	if player != null:
		direction = (player.global_position - global_position).normalized()
		velocity = direction * speed * delta

		# Flip sprite to face the player
		animated_sprite_2d.flip_h = direction.x > 0 
		print("Chasing player")

func _on_timer_timeout():
	if current_state == State.Chase:
		explode()
	elif current_state == State.Explode:
		# After explosion, you may want to reset or stop other processes
		pass

func _on_hurt_box_area_2d_area_entered(area):
	print("Hurtbox entered")
	if area.get_parent().has_method("get_damage_amount"):
		var node = area.get_parent() as Node
		health_amount -= node.damage_amount
		print("Health amount: ", health_amount) 
		
		if health_amount <= 0:
			explode()

func _on_attack_area_2d_body_entered(body : Node2D):
	if body.is_in_group("Player"):
		player = body
		current_state = State.Chase
		timer.wait_time = explosion_delay
		timer.start()
		print("Player detected, starting chase")

func _on_attack_area_2d_body_exited(body : Node2D):
	if body == player:
		player = null
		if current_state == State.Chase:
			current_state = State.Explode
			# Reset the timer to trigger explosion
			timer.wait_time = explosion_delay
			timer.start()
			print("Player exited attack area, starting explosion timer")

func explode():
	var enemy_attack_effect_instance = enemy_attack_effect.instantiate() as Node2D
	enemy_attack_effect_instance.global_position = global_position
	get_parent().add_child(enemy_attack_effect_instance)
	queue_free()
	print("Enemy exploded, death effect played")
	
func enemy_death(): 
	var enemy_death_effect_instance = enemy_death_effect.instantiate() as Node2D
	enemy_death_effect_instance.global_position = global_position
	get_parent().add_child(enemy_death_effect_instance)
	queue_free()
	print("Enemy died, death effect played")
	
	
# Animation control -- animation for state 
func enemy_animations():
	if current_state == State.Idle and not can_walk:
		print("Playing idle animation")
		animated_sprite_2d.play("fly") 
	elif current_state == State.Walk and can_walk:
		print("Playing walk animation")
		animated_sprite_2d.play("fly")



