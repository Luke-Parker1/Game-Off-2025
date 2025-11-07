extends CharacterBody2D

@export var health : float

var direction := 1.0

func _physics_process(_delta):
	print(direction)
	# Flip sword hitbox and floor detector
	if (direction > 0 and $Sword.position.x < 0) or (direction < 0 and $Sword.position.x > 0):
		$Sword.position.x *= -1
	if (direction > 0 and $FloorDetector.position.x < 0) or (direction < 0 and $FloorDetector.position.x > 0):
		$FloorDetector.position.x *= -1
	move_and_slide()

func hit(damage):
	health -= damage
	if health <= 0:
		queue_free()


func _on_hit_box_body_entered(body):
	if body.is_in_group("Player"):
		body.hit(global_position)
