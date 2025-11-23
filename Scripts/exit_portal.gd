extends Area2D

func _process(_delta):
	if get_tree().get_nodes_in_group("Enemy").size() == 0:
		$AnimatedSprite2D.play("active")
	else:
		$AnimatedSprite2D.play("default")
