extends CharacterBody2D

@export var speed : float

@export var health : float

var direction := 1.0


func _physics_process(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta
	if is_on_wall():
		direction *= -1
		$FloorDetector.position.x *= -1
	
	velocity.x = direction * speed
	move_and_slide()

func hit(damage):
	health -= damage
	if health <= 0:
		queue_free()

func _on_hit_box_body_entered(body):
	if body.is_in_group("Player"):
		# Determine if knockback is left or right
		#if global_position.direction_to(body.position).x >= 0:
			## This is "Greater or equal to" the default direction is right
			#body.knockback_direction = 1.0
		#else:
			#body.knockback_direction = -1.0
		body.hit(global_position)
		
