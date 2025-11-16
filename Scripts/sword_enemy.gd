extends CharacterBody2D

@export var health : float
@export var knockback_speed : Vector2
var knockback : Vector2

@onready var raycast_startpos = $RayCast2D.target_position

var direction := 1.0
var speed : float

# Whether the raycast should be its default length and size
var raycast_is_default := true

func _physics_process(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Flip sword hitbox, floor detector, and raycast
	if (direction > 0 and $Sword.position.x < 0) or (direction < 0 and $Sword.position.x > 0):
		$Sword.position.x *= -1
	if (direction > 0 and $FloorDetector.position.x < 0) or (direction < 0 and $FloorDetector.position.x > 0):
		$FloorDetector.position.x *= -1
	if ((direction > 0 and $RayCast2D.target_position.x < 0) or (direction < 0 and $RayCast2D.target_position.x  > 0)) and raycast_is_default:
		#print("flip raycast")
		$RayCast2D.target_position.x  *= -1
	
	velocity.x = direction * speed
	velocity += knockback
	move_and_slide()

func hit(damage : float, knockback_direction : Vector2):
	health -= damage
	knockback = knockback_direction * knockback_speed
	if damage > 0:
		$HitParticles.emitting = true
	$KnockbackTimer.start()
	if health <= 0:
		queue_free()


func _on_hit_box_body_entered(body):
	if body.is_in_group("Player"):
		body.hit(global_position)


func _on_knockback_timer_timeout():
	knockback = Vector2.ZERO


func _on_sword_body_entered(body):
	if body.is_in_group("Player"):
		body.hit(global_position)
