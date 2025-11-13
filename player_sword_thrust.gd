extends State
class_name PlayerSwordThrust

@export var Player : CharacterBody2D
@export var hitbox : CollisionShape2D

@export var thrust_timer : float
@export var thrust_speed : float

var thrust_time : float

var required_xp := 0.0

func Enter():
	Player.state_allows_default_move = false
	thrust_time = thrust_timer
	Player.velocity.y = 0
	hitbox.disabled = false

func State_Physics_Update(delta: float):
	Player.velocity.x = Player.look_direction * thrust_speed
	thrust_time -= delta
	
	if Player.knockback_direction != 0.0:
		Transitioned.emit(self, "knockback")
	elif thrust_time <= 0:
		Transitioned.emit(self, "default")

func Exit():
	hitbox.disabled = true
	Player.sword_xp -= required_xp
	Player.hit_enemies.clear()
	Player.get_node("SwordAttackCooldown").start()
