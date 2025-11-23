extends CharacterBody2D

@export var speed : float

@export var health : float
@export var contact_damage : float

@export var knockback_speed : Vector2
var knockback : Vector2

var direction := 1.0

@onready var default_sprite_scale = $Sprite2D.scale

# Keeps track of if the sprite is bouncing dowm or if it is returning to its default scale during walk cycle
var sprite_bouncing_down := true

var max_enemies : int
var enemies_left : int
const HEALTH_DROP := preload("uid://di0jxrmwns65l")

func _physics_process(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta
	elif is_on_wall() or $FloorDetector.get_overlapping_bodies().size() == 0:
		direction *= -1
		$FloorDetector.position.x *= -1
	
	velocity.x = direction * speed
	velocity += knockback
	move_and_slide()
	
	if is_on_floor():
		if sprite_bouncing_down:
			$Sprite2D.scale = $Sprite2D.scale.move_toward(default_sprite_scale  * Vector2(1.15, 0.85), 4*delta)
		else:
			$Sprite2D.scale = $Sprite2D.scale.move_toward(default_sprite_scale, 4*delta)
		if $Sprite2D.scale.is_equal_approx(default_sprite_scale):
			sprite_bouncing_down = true
		elif $Sprite2D.scale.is_equal_approx(default_sprite_scale * Vector2(1.15, 0.85)):
			sprite_bouncing_down = false
	else:
			$Sprite2D.scale = $Sprite2D.scale.move_toward(default_sprite_scale, 4*delta)

func hit(damage : float, knockback_direction : Vector2):
	health -= damage
	if damage > 0 and health > 0:
		$HitParticles.emitting = true
	knockback = knockback_direction * knockback_speed
	$KnockbackTimer.start()
	if health <= 0:
		$DieParticles.emitting = true
		$Sprite2D.visible = false
		$CollisionShape2D.set_deferred("disabled", true)
		$HitBox/CollisionShape2D.set_deferred("disabled", true)
		get_tree().get_current_scene().enemies_killed += 1
		if get_tree().get_current_scene().enemies_killed % 3 == 0:
			var health_drop = HEALTH_DROP.instantiate()
			health_drop.global_position = global_position
			call_deferred("add_sibling", health_drop)

func _on_hit_box_body_entered(body):
	if body.is_in_group("Player"):
		# Determine if knockback is left or right
		#if global_position.direction_to(body.position).x >= 0:
			## This is "Greater or equal to" the default direction is right
			#body.knockback_direction = 1.0
		#else:
			#body.knockback_direction = -1.0
		body.hit(global_position, contact_damage)
		


func _on_knockback_timer_timeout():
	knockback = Vector2.ZERO


func _on_die_particles_finished():
	queue_free()
