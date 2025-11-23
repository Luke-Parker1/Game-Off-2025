extends CharacterBody2D

var speed : float

@export var health : float
@export var contact_damage : float

@export var knockback_speed : Vector2
var knockback : Vector2

var direction := 1.0

@onready var raycast_startpos = $RayCast2D.target_position

@export var bullet_damage : float

var multiplier_bar : ProgressBar

@onready var default_sprite_scale = $AnimatedSprite2D.scale

# Keeps track of if the sprite is bouncing dowm or if it is returning to its default scale during walk cycle
var sprite_bouncing_down := true

var max_enemies : int
var enemies_left : int

const HEALTH_DROP := preload("uid://di0jxrmwns65l")

func _ready():
	multiplier_bar = get_tree().get_nodes_in_group("MultiplierBar")[0]

func _physics_process(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta
	#elif is_on_wall() or $FloorDetector.get_overlapping_bodies().size() == 0:
		#direction *= -1
		#$FloorDetector.position.x *= -1
	
	$RayCast2D.target_position = raycast_startpos * direction
	
	velocity.x = direction * speed
	velocity += knockback
	move_and_slide()
	
	if direction > 0:
		$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.flip_h = true
	$GunRotator.rotation = Vector2.ZERO.angle_to_point(Vector2(direction, 0))
	
	if is_on_floor() and $AnimatedSprite2D.animation == "walk":
		if sprite_bouncing_down:
			$AnimatedSprite2D.scale = $AnimatedSprite2D.scale.move_toward(default_sprite_scale  * Vector2(1.05, 0.95), delta)
		else:
			$AnimatedSprite2D.scale = $AnimatedSprite2D.scale.move_toward(default_sprite_scale, delta)
		if $AnimatedSprite2D.scale.is_equal_approx(default_sprite_scale):
			sprite_bouncing_down = true
		elif $AnimatedSprite2D.scale >= default_sprite_scale * Vector2(1.05, 0.95):
			sprite_bouncing_down = false
	else:
		$AnimatedSprite2D.scale = $AnimatedSprite2D.scale.move_toward(default_sprite_scale, delta)
	
	
	if (direction > 0 and $FloorDetector.position.x < 0) or (direction < 0 and $FloorDetector.position.x > 0):
		$FloorDetector.position.x *= -1

func hit(damage : float, knockback_direction : Vector2):
	health -= damage
	knockback = knockback_direction * knockback_speed
	if damage > 0 and health > 0:
		$HitParticles.emitting = true
	$KnockbackTimer.start()
	if health <= 0:
		$DieParticles.emitting = true
		$AnimatedSprite2D.visible = false
		$CollisionShape2D.set_deferred("disabled", true)
		$HitBox/CollisionShape2D.set_deferred("disabled", true)
		get_tree().get_current_scene().enemies_killed += 1
		if get_tree().get_current_scene().enemies_killed % 3 == 0:
			var health_drop = HEALTH_DROP.instantiate()
			health_drop.global_position = global_position
			call_deferred("add_sibling", health_drop)

func _on_hit_box_body_entered(body):
	if body.is_in_group("Player"):
		body.hit(global_position, contact_damage)


func _on_knockback_timer_timeout():
	knockback = Vector2.ZERO


func _on_die_particles_finished():
	queue_free()
