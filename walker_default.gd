extends State
class_name WalkerDefault

@export var Walker : CharacterBody2D

func Enter():
	Walker.state_allows_default_move = true
