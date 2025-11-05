extends CharacterBody2D

func _physics_process(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	move_and_slide()

func _on_hit_box_body_entered(body):
	if body.is_in_group("Player"):
		# Determine if knockback is left or right
		if global_position.direction_to(body.position).x >= 0:
			# This is "Greater or equal to" the default direction is right
			body.knockback_direction = 1.0
		else:
			body.knockback_direction = -1.0
		
