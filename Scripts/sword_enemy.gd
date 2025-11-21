extends CharacterBody2D

@export var health : float
@export var knockback_speed : Vector2
var knockback : Vector2

@onready var raycast_startpos = $RayCast2D.target_position

var direction := 1.0
var speed : float

# Whether the raycast should be its default length and size
var raycast_is_default := true

@onready var default_sprite_scale = $AnimatedSprite2D.scale

# Keeps track of if the sprite is bouncing dowm or if it is returning to its default scale during walk cycle
var sprite_bouncing_down := true

var sprite_bounce_scale := Vector2(1.05, 0.95)
var sprite_bounce_speed := 1.0

var multiplier_bar : ProgressBar

var max_enemies : int
var enemies_left : int
const HEALTH_DROP := preload("uid://di0jxrmwns65l")

func _ready():
	multiplier_bar = get_tree().get_nodes_in_group("MultiplierBar")[0]

func _physics_process(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Flip sword hitbox, floor detector, raycast and sprite
	if (direction > 0 and $Sword.position.x < 0) or (direction < 0 and $Sword.position.x > 0):
		$Sword.position.x *= -1
	if (direction > 0 and $FloorDetector.position.x < 0) or (direction < 0 and $FloorDetector.position.x > 0):
		$FloorDetector.position.x *= -1
	if ((direction > 0 and $RayCast2D.target_position.x < 0) or (direction < 0 and $RayCast2D.target_position.x  > 0)) and raycast_is_default:
		#print("flip raycast")
		$RayCast2D.target_position.x  *= -1
	if direction > 0:
		$AnimatedSprite2D.flip_h = false
		$Sword/AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.flip_h = true
		$Sword/AnimatedSprite2D.flip_h = true
	
	if $AnimatedSprite2D.animation == "walk":
		sprite_bounce_scale = Vector2(1.05, 0.95)
		sprite_bounce_speed = 1
	elif $AnimatedSprite2D.animation == "run":
		sprite_bounce_scale = Vector2(1.15, 0.85)
		sprite_bounce_speed = 4
	
	if is_on_floor() and velocity.x != 0:
		if sprite_bouncing_down:
			$AnimatedSprite2D.scale = $AnimatedSprite2D.scale.move_toward(default_sprite_scale  * sprite_bounce_scale, sprite_bounce_speed * delta)
		else:
			$AnimatedSprite2D.scale = $AnimatedSprite2D.scale.move_toward(default_sprite_scale, sprite_bounce_speed * delta)
		if $AnimatedSprite2D.scale.is_equal_approx(default_sprite_scale):
			sprite_bouncing_down = true
		elif $AnimatedSprite2D.scale >= default_sprite_scale * sprite_bounce_scale:
			sprite_bouncing_down = false
	else:
			$AnimatedSprite2D.scale = $AnimatedSprite2D.scale.move_toward(default_sprite_scale, sprite_bounce_speed*delta)
	
	velocity.x = direction * speed
	velocity += knockback
	move_and_slide()
	
	# Make sword be white when damage is zero
	if multiplier_bar.right_type_mult == 0:
		$Sword/AnimatedSprite2D.material.set_shader_parameter("active", true)
	else:
		$Sword/AnimatedSprite2D.material.set_shader_parameter("active", false)

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
		$Sword/AnimatedSprite2D.visible = false
		$Sword/CollisionShape2D.set_deferred("disabled", true)
		get_tree().get_current_scene().enemies_killed += 1
		if get_tree().get_current_scene().enemies_killed % 3 == 0:
			var health_drop = HEALTH_DROP.instantiate()
			health_drop.global_position = global_position
			call_deferred("add_sibling", health_drop)


func _on_hit_box_body_entered(body):
	if body.is_in_group("Player"):
		body.hit(global_position)


func _on_knockback_timer_timeout():
	knockback = Vector2.ZERO


func _on_sword_body_entered(body):
	if body.is_in_group("Player"):
		body.hit(global_position)


func _on_die_particles_finished():
	queue_free()
