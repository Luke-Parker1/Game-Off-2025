extends CharacterBody2D

@export var speed : float

@export var health : float

@export var knockback_speed : Vector2
var knockback : Vector2

var direction := 1.0


func _physics_process(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta
	elif is_on_wall() or $FloorDetector.get_overlapping_bodies().size() == 0:
		direction *= -1
		$FloorDetector.position.x *= -1
	
	velocity.x = direction * speed
	velocity += knockback
	move_and_slide()

func hit(damage : float, knockback_direction : Vector2):
	health -= damage
	if damage > 0:
		$HitParticles.emitting = true
	knockback = knockback_direction * knockback_speed
	$KnockbackTimer.start()
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
		


func _on_knockback_timer_timeout():
	knockback = Vector2.ZERO
