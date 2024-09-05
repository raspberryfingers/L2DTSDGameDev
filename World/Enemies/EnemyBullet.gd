extends AnimatedSprite2D

var bullet_impact_effect = preload("res://Player/Assets/bulleteffect/Bullet Impact/bullet_impact_effect.tscn")

@export var speed : int = 350
@export var direction : int 
@export var damage_amount : int = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_local_x(direction * speed * delta)

func _on_timer_timeout():
	queue_free()

func _on_hitbox_area_2d_body_entered(body):
	if body.is_in_group("Enemy"):
		return
	else:
		print("bullet body entered")
		bullet_impact() 


func _on_hitbox_area_2d_area_entered(area):
	if area.is_in_group("Enemy"):
		return
	else:
		print("bullet body entered")
		bullet_impact() 

	
func get_damage_amount() -> int: 
	return damage_amount 
	
func bullet_impact():
	var bullet_impact_effect_instance = bullet_impact_effect.instantiate() as Node2D
	bullet_impact_effect_instance.global_position = global_position 
	get_parent().add_child(bullet_impact_effect_instance)
	queue_free()
