extends Area2D

@export var health : float

func _on_body_entered(body):
	if body.is_in_group("Player"):
		$Sprite2D.visible = false
		$CollisionShape2D.set_deferred("disabled", true)
		$CPUParticles2D.emitting = false
		$DieParticles.emitting = true
		body.health += health


func _on_die_particles_finished():
	queue_free()
