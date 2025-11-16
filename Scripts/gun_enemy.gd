extends CharacterBody2D

var speed : float

@export var health : float

@export var knockback_speed : Vector2
var knockback : Vector2

var direction := 1.0

@onready var raycast_startpos = $RayCast2D.target_position

@export var bullet_damage : float

var multiplier_bar : ProgressBar

func _ready():
	multiplier_bar = get_tree().get_nodes_in_group("MultiplierBar")[0]

func _physics_process(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta
	#elif is_on_wall() or $FloorDetector.get_overlapping_bodies().size() == 0:
		#direction *= -1
		#$FloorDetector.position.x *= -1
	
	$RayCast2D.target_position = raycast_startpos * direction
	
	velocity.x = direction * speed
	velocity += knockback
	move_and_slide()
	
	$GunRotator.rotation = Vector2.ZERO.angle_to_point(Vector2(direction, 0))

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
