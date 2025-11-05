extends State
class_name PlayerDefault

# This is the default state for the player
# The player can move and jump in this state (that code is in the player script), but nothing else

@export var Player : CharacterBody2D

func Enter():
	Player.state_allows_default_move = true


func State_Physics_Update(_delta: float):
	if Player.knockback_direction != 0.0:
		Transitioned.emit(self, "knockback")
	elif Input.is_action_just_pressed("dash") and Player.get_node("DashCoolDown").is_stopped():
		Transitioned.emit(self, "dash")
	elif Input.is_action_just_pressed("sword") and Player.get_node("SwordAttackCooldown").is_stopped():
		Transitioned.emit(self, "swordattack")
	elif Input.is_action_just_pressed("shoot") and Player.get_node("ShootCooldown").is_stopped():
		Transitioned.emit(self, "shoot")
