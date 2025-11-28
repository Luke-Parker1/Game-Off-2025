extends State
class_name PlayerKnockback

@export var Player : CharacterBody2D

# How strong the knockback should be
@export var knockback_force : float

@export var stun_timer : float
@export var knockback_timer : float

# Time stun has left
var stun_time : float
# Time the knockback has left
var knockback_time : float


func Enter():
	Player.state_allows_default_move = false
	Player.state_allows_animation = false
	stun_time = stun_timer
	knockback_time = knockback_timer
	Player.velocity = Vector2.ZERO
	frame_freeze(0.05, stun_timer)
	Player.get_node("AnimatedSprite2D").play("hit")
	Player.get_node("HitParticles").emitting = true
	Player.get_node("HurtSound").play()

func State_Physics_Update(delta: float):
	#if stun_time < 0:
		#Player.velocity = Vector2(Player.knockback_direction, -.5).normalized() * knockback_force
		#knockback_time -= delta
	#else:
		#stun_time -= delta
	
	Player.velocity = Vector2(Player.knockback_direction, -.5).normalized() * knockback_force
	knockback_time -= delta
	
	if knockback_time <= 0:
		if Player.health > 0:
			Transitioned.emit(self, "default")
		else:
			Transitioned.emit(self, "die")

func Exit():
	Player.knockback_direction = 0

func frame_freeze(timeScale, duration):
	Engine.time_scale = timeScale
	await get_tree().create_timer(duration * timeScale).timeout
	Engine.time_scale = 1.0
