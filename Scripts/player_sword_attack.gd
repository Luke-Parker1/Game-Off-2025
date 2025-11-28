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
var required_xp := 0.0

# Volume of sound effect
@export var volume : float

func Enter():
	Player.state_allows_default_move = true
	Player.state_allows_animation = true
	attack_time = attack_timer
	hitbox.disabled = false
	Player.sword_xp -= required_xp
	hitbox.get_node("AnimatedSprite2D").visible = true
	hitbox.get_node("AnimatedSprite2D").play("attack")
	if Player.look_direction > 0:
		hitbox.get_node("AnimatedSprite2D").flip_v = false
	else:
		hitbox.get_node("AnimatedSprite2D").flip_v = true
	
	Player.get_node("SwordSound").volume_db = volume
	Player.get_node("SwordSound").play()

func State_Physics_Update(delta: float):
	attack_time -= delta
	if Player.knockback_direction != 0.0:
		Transitioned.emit(self, "knockback")
	
	elif attack_time <= 0:
		Transitioned.emit(self, "default")

func Exit():
	hitbox.disabled = true
	hitbox.get_node("AnimatedSprite2D").visible = false
	if Player.hit_enemies.size() > 0 and gives_xp:
		Player.sword_xp += Player.multiplier_bar.right_type_mult
	Player.hit_enemies.clear()
	Player.get_node("SwordAttackCooldown").start()
