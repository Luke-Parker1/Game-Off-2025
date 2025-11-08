extends State
class_name GunEnemyDefault

@export var Enemy : CharacterBody2D
@export var speed : float

func State_Physics_Update(_delta: float):
	if (Enemy.is_on_wall() or Enemy.get_node("FloorDetector").get_overlapping_bodies().size() == 0) and Enemy.is_on_floor():
		Enemy.direction *= -1
		Enemy.get_node("FloorDetector").position.x *= -1
	
	Enemy.speed = speed
	
	if Enemy.get_node("RayCast2D").is_colliding():
		if Enemy.get_node("RayCast2D").get_collider().is_in_group("Player") and Enemy.get_node("GunCooldown").is_stopped():
			Transitioned.emit(self, "shoot")
