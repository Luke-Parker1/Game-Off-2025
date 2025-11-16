extends State
class_name PlayerSwordThrust

@export var Player : CharacterBody2D
@export var hitbox : CollisionShape2D

@export var thrust_timer : float
@export var thrust_speed : float
@export var effect_num : int

var current_effect_num : int

var thrust_time : float

var required_xp := 0.0

func Enter():
	Player.state_allows_default_move = false
	Player.state_allows_animation = false
	thrust_time = thrust_timer
	Player.velocity.y = 0
	hitbox.disabled = false
	current_effect_num = effect_num
	hitbox.get_node("AnimatedSprite2D").visible = true
	hitbox.get_node("AnimatedSprite2D").play("attack")
	if Player.look_direction > 0:
		hitbox.get_node("AnimatedSprite2D").flip_v = false
	else:
		hitbox.get_node("AnimatedSprite2D").flip_v = true

func State_Physics_Update(delta: float):
	Player.get_node("AnimatedSprite2D").play("sword thrust")
	Player.velocity.x = Player.look_direction * thrust_speed
	thrust_time -= delta
	if thrust_time <= thrust_timer * current_effect_num/effect_num:
		current_effect_num -= 1
		Player.create_dash_effect(thrust_timer/effect_num)
	
	if Player.knockback_direction != 0.0:
		Transitioned.emit(self, "knockback")
	elif thrust_time <= 0:
		Transitioned.emit(self, "default")

func Exit():
	hitbox.disabled = true
	Player.sword_xp -= required_xp
	Player.hit_enemies.clear()
	hitbox.get_node("AnimatedSprite2D").visible = false
	Player.get_node("SwordAttackCooldown").start()
