extends State
class_name SwordEnemyDefault

@export var Enemy : CharacterBody2D
@export var speed : float

func State_Physics_Update(delta: float):
	if not Enemy.is_on_floor():
		Enemy.velocity += Enemy.get_gravity() * delta
	elif Enemy.is_on_wall() or Enemy.get_node("FloorDetector").get_overlapping_bodies().size() == 0:
		#print("bounce")
		Enemy.direction *= -1
		Enemy.get_node("FloorDetector").position.x *= -1
	
	Enemy.velocity.x = Enemy.direction * speed
