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
	stun_time = stun_timer
	knockback_time = knockback_timer
	Player.velocity = Vector2.ZERO

func State_Physics_Update(delta: float):
	if stun_time < 0:
		Player.velocity = Vector2(Player.knockback_direction, -.5).normalized() * knockback_force
		knockback_time -= delta
	else:
		stun_time -= delta
	
	if knockback_time <= 0:
		Transitioned.emit(self, "default")

func Exit():
	Player.knockback_direction = 0
