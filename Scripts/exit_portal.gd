extends Area2D

func _process(_delta):
	if get_tree().get_nodes_in_group("Enemy").size() == 0:
		$AnimatedSprite2D.play("active")
		$CPUParticles2D.emitting = true
	else:
		$AnimatedSprite2D.play("default")
		$CPUParticles2D.emitting = false
