extends State
class_name SwordEnemyChase

@export var speed : float
@export var Enemy : CharacterBody2D
var Player : CharacterBody2D
var raycast : RayCast2D

@export var min_distance : float
var initial_direction

# Amount of time it will take to go back to default if the player is hidden
@export var forget_timer : float
var forget_time : float

# If this is true, the player is behind the enemy
var player_behind_enemy := false

# Time that enemy takes to skid to a stop after the playergoes behind the enemy
@export var skid_timer : float
var skid_time : float

# Checks if the chase state should proceed or not.
# This may be true if the enemy is hit with a bullet and doesn't actually have a line of sight to the player
var return_to_default := false



func Enter():
	return_to_default = false
	player_behind_enemy = false
	
	Player = get_tree().get_nodes_in_group("Player")[0]
	Enemy.velocity.x = 0
	raycast = Enemy.get_node("RayCast2D")
	raycast.target_position = Player.global_position - Enemy.global_position
	Enemy.raycast_is_default = false
	
	raycast.force_raycast_update()
	if raycast.get_collider() != Player:
		#print("Original Check: ", raycast.get_collider())
		return_to_default = true
	elif (Enemy.direction > 0 and raycast.target_position.x < 0) or (Enemy.direction < 0 and raycast.target_position.x  > 0):
		Enemy.direction  *= -1
	
	forget_time = forget_timer
	skid_time = skid_timer
	Enemy.speed = speed
	Enemy.get_node("AnimatedSprite2D").play("run")

func State_Physics_Update(delta: float):
	#if return_to_default:
		#print(raycast.get_collider())
	raycast.target_position = Player.global_position - Enemy.global_position
	#if (Enemy.direction > 0 and raycast.target_position.x < 0) or (Enemy.direction < 0 and raycast.target_position.x  > 0):
		#Enemy.direction  *= -1
	
	#Enemy.velocity.x = Enemy.direction * speed
	
	if raycast.get_collider() != Player:
		forget_time -= delta
	else:
		forget_time = forget_timer
	
	if (Enemy.direction > 0 and raycast.target_position.x < 0) or (Enemy.direction < 0 and raycast.target_position.x  > 0):
		player_behind_enemy = true
	
	if player_behind_enemy:
		skid_time -= delta
	
	if (Enemy.is_on_wall() or Enemy.get_node("FloorDetector").get_overlapping_bodies().size() == 0) and Enemy.is_on_floor():
		Enemy.speed = 0
	else:
		Enemy.speed = speed
	
	if return_to_default or forget_time <= 0 or skid_time <= 0:
		Transitioned.emit(self, "default")
	elif Enemy.global_position.distance_squared_to(Player.global_position) <= min_distance**2:
		Transitioned.emit(self, "attack")

func Exit():
	raycast.target_position = Enemy.raycast_startpos * Enemy.direction
