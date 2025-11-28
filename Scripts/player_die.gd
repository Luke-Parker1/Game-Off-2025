extends State
class_name PlayerDie

@export var Player : CharacterBody2D

func Enter():
	Player.state_allows_default_move = false
	Player.state_allows_animation = false
	Player.velocity = Vector2.ZERO
	Player.get_node("AnimatedSprite2D").visible = false
	Player.get_node("DieParticles").emitting = true
	Player.get_node("DeathSound").play()
