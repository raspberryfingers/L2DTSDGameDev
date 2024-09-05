extends CharacterBody2D

# Upload scenes outside of node 
var bullet = preload("res://player/Assets/bulleteffect/bullet_3.tscn")
var player_death_effect = preload("res://Player/PlayerDeath/PlayerDeathEffect.tscn")

# A reference to the AnimatedSprite2D, Marker2D, Timer nodes 
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var muzzle : Marker2D = $Muzzle 
@onready var shoot_timer : Timer = $ShootTimer
@onready var hit_animation_player : AnimationPlayer = $HitAnimationPlayer

# Export variables for easy tweaking in the side editor
@export var gravity: float = 1000 
@export var speed: float = 300 
@export var jump: float = -500
@export var jump_horizontal_speed: int = 1000
@export var max_jump_horizontal_speed: int = 300 

# Handle states 
enum State { Idle, Run, Jump, Shoot, Fall, Crouch, Climb_Down, Climb_Up }

var current_state: State
var muzzle_position 
var on_ladder: bool = false
# Track the last facing direction 
var last_direction: float = 1.0 

var current_sprite: Sprite2D   

# Start in idle position 
func _ready():
	current_state = State.Idle
	muzzle_position = muzzle.position 
	print("Starting state: Idle")

# Functions 
func _physics_process(delta : float):
	player_falling(delta)  
	player_idle(delta)
	player_run(delta)
	player_jump(delta)
	player_crouch(delta)
	player_climbing(delta)
	player_shooting(delta)
	
	player_muzzle_position()
	move_and_slide() 
	
	player_animations()

# Fall state conditions  
func player_falling(delta : float): 
	if not is_on_floor() and !on_ladder:
		velocity.y += gravity * delta

# Idle state conditions		
func player_idle(_delta : float): 
	if is_on_floor() and current_state != State.Shoot:
		current_state = State.Idle  
		print("State changed to: Idle")

# Climb state conditions 
func player_climbing(delta: float):
	if on_ladder:
		if Input.is_action_pressed("climb_down"):
			velocity.y = speed * delta * 10
			if velocity.y > 0:
				current_state = State.Climb_Down
		elif Input.is_action_pressed("climb_up"):
			velocity.y = -speed * delta * 10
			current_state = State.Climb_Up
		else:
			velocity.y = 0

		print("on ladder")

# Run state conditions 		
func player_run(delta : float):
	# Handle player input 
	var direction = input_movement()
	
	if direction:
		velocity.x = direction * speed 
	else:
		velocity.x = move_toward(velocity.x, 0, speed) 
	
	# Player must be on floor to be in state run 	
	if direction != 0 and is_on_floor():
		current_state = State.Run
		animated_sprite_2d.flip_h = direction < 0
		print("State changed to: Run")
	
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0

# Jump state conditions 		
func player_jump(delta): 
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = jump  # Use the exported jump value
		current_state = State.Jump
		print("State changed to: Jump")
	
	# Movement while jumping 	
	if !is_on_floor() and current_state == State.Jump:
		var direction = input_movement()
		velocity.x += direction * jump_horizontal_speed * delta 
		velocity.x = clamp(velocity.x, -max_jump_horizontal_speed, max_jump_horizontal_speed)

func player_crouch(_delta : float): 
	if is_on_floor() and Input.is_action_pressed("crouch"): 
		current_state = State.Crouch
		print("State changed to: Crouch")

# Play the bullet scene when conditions met 
func player_shooting(delta : float): 
	var direction = input_movement()
	if direction:
		last_direction = direction

	if Input.is_action_just_pressed("shoot"):
		var bullet_instance = bullet.instantiate() as Node2D
		# Use the last direction if no input
		bullet_instance.direction = last_direction
		bullet_instance.global_position = muzzle.global_position
		get_parent().add_child(bullet_instance)
		current_state = State.Shoot
		shoot_timer.start(0.4)
		print("State changed to: Shoot")

# When shoot timer runs out change state unless shooting again 
func _on_shoot_timer_timeout():
	if Input.is_action_just_pressed("shoot"):
		current_state = State.Shoot 
	else: 
		if velocity.x == 0: 
			current_state = State.Idle 
		else: 
			current_state = State.Run 

# Muzzle direction to flip if the player also flips (direction)  
func player_muzzle_position():
	var direction = input_movement()
	
	if direction > 0: 
		muzzle.position.x = muzzle_position.x 
	elif direction < 0: 
		muzzle.position.x = -muzzle_position.x 
		
func _on_area_2d_body_entered(body: Node2D) -> void:
	if "Player" in body.name: 
		on_ladder = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if "Player" in body.name: 
		on_ladder = false 
	
# Animation control  
func player_animations():
	if current_state == State.Idle and velocity.x == 0 and velocity.y == 0:
		animated_sprite_2d.play("idle") 
	elif current_state == State.Run:
		animated_sprite_2d.play("run")
	# Only play jump animation to only play when going up 
	elif current_state == State.Jump and velocity.y < 0:
		animated_sprite_2d.play("jump")
	elif current_state == State.Climb_Down and velocity.y > 0 and on_ladder:
		animated_sprite_2d.play("climb_down")
		print("Playing climb animation")
	elif current_state == State.Climb_Up and on_ladder:
		animated_sprite_2d.play("climb_up")
	# Play crouch 
	elif current_state == State.Crouch:
		animated_sprite_2d.play("crouch")
	elif current_state == State.Shoot and animated_sprite_2d.animation != "crouch" and velocity.x == 0 and velocity.y == 0:
		animated_sprite_2d.play("shoot")
	# Fall animation to play when falling from jump but state still = jump 
	elif velocity.y > 0: 
		animated_sprite_2d.play("fall")
		
func player_death(): 
	var player_death_effect_instance = player_death_effect.instantiate() as Node2D 
	player_death_effect_instance.global_position = global_position
	get_parent().add_child(player_death_effect_instance)
	queue_free()

# Direction = input movement 
func input_movement(): 
	var direction : float = Input.get_axis("move_left", "move_right")
	return direction 

func _on_hurtbox_body_entered(body : Node2D):
	print("Hurtbox entered")
	if body.is_in_group("Enemy"):
		print("Enemy Entered ", body.damage_amount)
		hit_animation_player.play("hit")
		HealthManager.decrease_health(body.damage_amount) 
				
	if HealthManager.current_health < 1: 
		player_death()
