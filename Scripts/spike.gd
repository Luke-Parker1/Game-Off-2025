extends Area2D

@export var damage : float

func _on_body_entered(body):
	if body.is_in_group("Player"):
		body.hit(global_position, damage)
	elif body.is_in_group("Enemy"):
		body.hit(body.health, global_position.direction_to(body.global_position))
