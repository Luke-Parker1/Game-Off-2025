extends State
class_name SwordEnemyDefault

@export var Enemy : CharacterBody2D
@export var speed : float

func Enter():
	Enemy.raycast_is_default = true

func State_Physics_Update(_delta: float):
	if (Enemy.is_on_wall() or Enemy.get_node("FloorDetector").get_overlapping_bodies().size() == 0) and Enemy.is_on_floor():
		#print("bounce")
		Enemy.direction *= -1
		Enemy.get_node("FloorDetector").position.x *= -1
	
	#Enemy.velocity.x = Enemy.direction * speed
	Enemy.speed = speed
	if Enemy.get_node("RayCast2D").is_colliding():
		if Enemy.get_node("RayCast2D").get_collider().is_in_group("Player"):
			Transitioned.emit(self, "chase")
	if !Enemy.knockback.is_equal_approx(Vector2.ZERO):
			Transitioned.emit(self, "chase")
		
