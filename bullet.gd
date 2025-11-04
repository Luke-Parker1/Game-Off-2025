extends Area2D

var direction : Vector2
@export var speed : float

# Entity that shot this bullet
var shooter : CharacterBody2D

func _physics_process(delta):
	position += direction * speed * delta


func _on_body_entered(body):
	if body != shooter:
		queue_free()
