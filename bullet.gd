extends Area2D

var direction : Vector2
@export var speed : float

# Entity that shot this bullet
var shooter : CharacterBody2D

var damage : float

func _ready():
	direction = Vector2.from_angle(rotation)

func _physics_process(delta):
	position += direction * speed * delta


func _on_body_entered(body):
	if body != shooter:
		if body.is_in_group("Enemy") and shooter.is_in_group("Player"):
			body.hit(damage, direction)
		elif body.is_in_group("Player") and shooter.is_in_group("Enemy"):
			body.hit(global_position)
		queue_free()
