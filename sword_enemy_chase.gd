extends State
class_name SwordEnemyChase

@export var speed : float
@export var Enemy : CharacterBody2D
var Player : CharacterBody2D
var raycast : RayCast2D

@export var min_distance : float
var initial_direction

func Enter():
	Player = get_tree().get_nodes_in_group("Player")[0]
	Enemy.velocity = Vector2.ZERO
	raycast = Enemy.get_node("RayCast2D")
	raycast.target_position = Player.global_position - Enemy.global_position
	Enemy.raycast_is_default = false
	if (Enemy.direction > 0 and raycast.target_position.x < 0) or (Enemy.direction < 0 and raycast.target_position.x  > 0):
		Enemy.direction  *= -1

func State_Physics_Update(_delta: float):
	raycast.target_position = Player.global_position - Enemy.global_position
	#if (Enemy.direction > 0 and raycast.target_position.x < 0) or (Enemy.direction < 0 and raycast.target_position.x  > 0):
		#Enemy.direction  *= -1
	
	Enemy.velocity.x = Enemy.direction * speed
