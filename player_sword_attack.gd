extends State
class_name PlayerSwordAttack

@export var Player : CharacterBody2D

# How much time the attack is active for
@export var attack_timer : float

# How much time the attack has left
var attack_time : float

var hitbox : CollisionShape2D

func Enter():
	Player.state_allows_default_move = true
	attack_time = attack_timer
	hitbox = Player.get_node("SwordAttackHitbox/CollisionShape2D")
	hitbox.disabled = false

func State_Physics_Update(delta: float):
	attack_time -= delta
	if Player.knockback_direction != 0.0:
		Transitioned.emit(self, "knockback")
	elif attack_time <= 0:
		Transitioned.emit(self, "default")

func Exit():
	hitbox.disabled = true
	Player.get_node("SwordAttackCooldown").start()
