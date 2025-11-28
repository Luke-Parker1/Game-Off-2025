extends State
class_name PlayerDash

# This is the state for when the player is dashing

@export var Player : CharacterBody2D
@export var dash_timer := 0.0
@export var dash_speed := 500.0
@export var effect_num : int

var current_effect_num : int

# Current amount of time the dash has left
var dash_time : float

func Enter():
	Player.state_allows_default_move = false
	Player.state_allows_animation = false
	dash_time = dash_timer
	Player.velocity.y = 0
	current_effect_num = effect_num
	Player.get_node("DashSound").play()

func State_Physics_Update(delta: float):
	Player.get_node("AnimatedSprite2D").play("dash")
	Player.velocity.x = Player.look_direction * dash_speed
	if dash_time <= dash_timer * current_effect_num/effect_num:
		current_effect_num -= 1
		Player.create_dash_effect(dash_timer/effect_num)
	dash_time -= delta
	
	if Player.knockback_direction != 0.0:
		Transitioned.emit(self, "knockback")
	elif Input.is_action_just_pressed("sword") and Player.get_node("SwordAttackCooldown").is_stopped():
		Transitioned.emit(self, "swordattack")
	elif Input.is_action_just_pressed("big sword") and Player.get_node("SwordAttackCooldown").is_stopped() and Player.big_sword_check():
		Transitioned.emit(self, "bigswordattack")
	elif Input.is_action_just_pressed("sword thrust") and Player.get_node("SwordAttackCooldown").is_stopped() and Player.sword_thrust_check():
		Transitioned.emit(self, "swordthrust")
	elif Input.is_action_just_pressed("shoot") and Player.get_node("ShootCooldown").is_stopped():
		Transitioned.emit(self, "shoot")
	elif Input.is_action_just_pressed("big shoot") and Player.get_node("ShootCooldown").is_stopped() and Player.big_shoot_check():
		Transitioned.emit(self, "bigshoot")
	elif dash_time <= 0:
		Transitioned.emit(self, "default")
	
	

func Exit():
	Player.get_node("DashCoolDown").start()
