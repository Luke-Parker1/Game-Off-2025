extends Area2D

var direction : Vector2
@export var speed : float

# Entity that shot this bullet
var shooter : CharacterBody2D

var damage : float

@export var is_big_bullet : bool

# Saving this as a variable because checking is_in_group when the bullet collides could happen after the enemy dies
var shooter_is_player : bool

func _ready():
	direction = Vector2.from_angle(rotation)

func _physics_process(delta):
	position += direction * speed * delta


func _on_body_entered(body):
	if body != shooter:
		if body.is_in_group("Enemy") and shooter_is_player:
			body.hit(damage, direction)
			if !is_big_bullet:
				shooter.gun_xp += shooter.multiplier_bar.left_type_mult
		elif body.is_in_group("Player") and !shooter_is_player:
			body.hit(global_position)
		queue_free()
