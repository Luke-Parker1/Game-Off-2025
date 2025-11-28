extends Area2D

var direction : Vector2
@export var speed : float
@export var knockback_mult := Vector2(1,1)

# Entity that shot this bullet
var shooter : CharacterBody2D

var damage : float

# Saving this as a variable because checking is_in_group when the bullet collides could happen after the enemy dies
var shooter_is_player : bool

# Array of who has been hit by the explosion
var hit_bodies : Array

func _ready():
	direction = Vector2.from_angle(rotation)
	if damage > 0:
		$ExplosionParticles.color = Color("ff0456")
		$Sprite2D.material.set_shader_parameter("active", false)
	else:
		$ExplosionParticles.color = Color.WHITE
		$Sprite2D.material.set_shader_parameter("active", true)

func _physics_process(delta):
	if $ExplosionTimer.is_stopped():
		position += direction * speed * delta


func _on_body_entered(body):
	if body != shooter and !(body.is_in_group("Enemy") and !shooter_is_player) and !(body.is_in_group("Player") and shooter_is_player):
		#$ExplosionHitBox/CollisionShape2D.disabled = false
		$Sprite2D.visible = false
		$ExplosionHitBox/CollisionShape2D.set_deferred("disabled", false)
		$ExplosionParticles.emitting = true
		$ExplodeSound.play()
		$ExplosionTimer.start()


func _on_explosion_hit_box_body_entered(body):
	if body != shooter and !hit_bodies.has(body):
		if body.is_in_group("Enemy") and shooter_is_player:
			body.hit(damage, global_position.direction_to(body.global_position) * knockback_mult)
		elif body.is_in_group("Player") and !shooter_is_player:
			body.hit(global_position, damage)
		hit_bodies.append(body)


func _on_explosion_timer_timeout():
	queue_free()
