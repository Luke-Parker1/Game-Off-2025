extends State
class_name PlayerShoot

@export var Player : CharacterBody2D

const BULLET := preload("uid://cwcomh31mp8tt")

func Enter():
	Player.state_allows_default_move = true
	var bullet = BULLET.instantiate()
	bullet.global_position = Player.global_position
	bullet.direction = Vector2(Player.look_direction, 0)
	bullet.shooter = Player
	Player.add_sibling(bullet)

func State_Physics_Update(_delta: float):
	if Player.knockback_direction != 0.0:
		Transitioned.emit(self, "knockback")
	else:
		Transitioned.emit(self, "default")

func Exit():
	Player.get_node("ShootCooldown").start()
