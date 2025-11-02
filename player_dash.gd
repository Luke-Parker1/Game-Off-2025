extends State
class_name PlayerDash

# This is the state for when the player is dashing

@export var Player : CharacterBody2D
@export var dash_timer := 0.0
@export var dash_speed := 500.0

var dash_timer_time : float

func Enter():
	Player.state_allows_default_move = false
	dash_timer_time = dash_timer
	Player.velocity.y = 0

func State_Physics_Update(delta: float):
	Player.velocity.x = Player.look_direction * dash_speed
	dash_timer_time -= delta
	if dash_timer_time <= 0:
		Player.get_node("DashCoolDown").start()
		Transitioned.emit(self, "default")
