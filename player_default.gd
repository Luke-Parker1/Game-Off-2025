extends State
class_name PlayerDefault

# This is the default state for the player
# The player can move and jump in this state (that code is in the player script), but nothing else

@export var Player : CharacterBody2D

func Enter():
	Player.state_allows_default_move = true
	Player.state_allows_jump = true

func State_Physics_Update(_delta: float):
	if Input.is_action_just_pressed("dash") and Player.get_node("DashCoolDown").is_stopped():
		Transitioned.emit(self, "dash")
