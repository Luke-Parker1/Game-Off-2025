extends State
class_name SwordEnemyAttack

@export var Enemy : CharacterBody2D

# Timers for windup, attack, and cooldown
@export var windup_timer : float
@export var attack_timer : float
@export var cooldown_timer : float

var windup_time : float
var attack_time : float
var cooldown_time : float


func Enter():
	Enemy.velocity.x = 0
	Enemy.speed = 0
	windup_time = windup_timer
	attack_time = attack_timer
	cooldown_time = cooldown_timer

func State_Physics_Update(delta: float):
	if windup_time > 0:
		windup_time -= delta
	elif attack_time > 0:
		Enemy.get_node("Sword/CollisionShape2D").disabled = false
		attack_time -= delta
	elif cooldown_time > 0:
		cooldown_time -= delta
		Enemy.get_node("Sword/CollisionShape2D").disabled = true
	else:
		Transitioned.emit(self, "chase")
