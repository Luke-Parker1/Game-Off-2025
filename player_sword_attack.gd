extends State
class_name PlayerSwordAttack

@export var Player : CharacterBody2D

# How much time the attack is active for
@export var attack_timer : float

# How much time the attack has left
var attack_time : float

@export var hitbox : CollisionShape2D

# Whether or not this should give xp. This would be no for a special attack
@export var gives_xp : bool

# Amount of xp required for this attack
var required_xp := 0

func Enter():
	Player.state_allows_default_move = true
	attack_time = attack_timer
	hitbox.disabled = false

func State_Physics_Update(delta: float):
	attack_time -= delta
	if Player.knockback_direction != 0.0:
		Transitioned.emit(self, "knockback")
	
	elif attack_time <= 0:
		Transitioned.emit(self, "default")

func Exit():
	hitbox.disabled = true
	if Player.hit_enemies.size() > 0 and gives_xp:
		Player.sword_xp += Player.multiplier_bar.right_type_mult
	Player.sword_xp -= required_xp
	Player.hit_enemies.clear()
	Player.get_node("SwordAttackCooldown").start()
