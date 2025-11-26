extends State
class_name GunEnemyShoot

@export var Enemy : CharacterBody2D

# Timers for windup and cooldown
@export var windup_timer : float
@export var cooldown_timer : float

var windup_time : float
var cooldown_time : float

@export var BULLET : PackedScene

var shot := false

func Enter():
	Enemy.velocity.x = 0
	Enemy.speed = 0
	windup_time = windup_timer
	cooldown_time = cooldown_timer
	shot = false
	Enemy.get_node("AnimatedSprite2D").play("default")

func State_Physics_Update(delta: float):
	if windup_time > 0:
		windup_time -= delta
	elif windup_time <= 0 and !shot and Enemy.health > 0:
		var bullet = BULLET.instantiate()
		bullet.global_position = Enemy.get_node("GunRotator/ShootPosition").global_position
		bullet.global_rotation = Enemy.get_node("GunRotator/ShootPosition").global_rotation
		bullet.shooter = Enemy
		bullet.shooter_is_player = false
		bullet.damage = Enemy.bullet_damage * Enemy.multiplier_bar.left_type_mult
		Enemy.add_sibling(bullet)
		Enemy.get_node("GunRotator/ShootParticles").emitting = true
		shot = true
	elif cooldown_time > 0:
		cooldown_time -= delta
	else:
		Transitioned.emit(self, "default")

func Exit():
	Enemy.get_node("GunCooldown").start()
