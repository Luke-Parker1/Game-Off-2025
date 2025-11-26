extends Area2D

func _process(_delta):
	if get_tree().get_nodes_in_group("Enemy").size() == 0:
		$AnimatedSprite2D.play("active")
		$CPUParticles2D.emitting = true
	else:
		$AnimatedSprite2D.play("default")
		$CPUParticles2D.emitting = false


func _on_body_entered(body):
	if body.is_in_group("Player") and get_tree().get_nodes_in_group("Enemy").size() == 0:
		#get_tree().change_scene_to_file("res://Scenes/level_clear.tscn")
		get_tree().call_deferred("change_scene_to_file", "res://Scenes/level_clear.tscn")
