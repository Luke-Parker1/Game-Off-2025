extends CharacterBody2D

@export var health : float

@export var speed := 300.0
@export var dash_speed := 500.0

@export var jump_height : float
@export var jump_time_to_peak : float
@export var jump_time_to_descent : float

@onready var jump_velocity : float = ((2.0*jump_height)/jump_time_to_peak) * -1.0
@onready var jump_gravity : float = ((-2.0*jump_height)/(jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity : float = ((-2.0*jump_height)/(jump_time_to_descent * jump_time_to_descent)) * -1.0

@export var recoil_speed : float
@export var recoil_time : float

# Recoil time when pogoing
@export var pogo_time : float

@export var sword_attack_damage : float
@export var big_sword_damage : float
@export var sword_thrust_damage : float
@export var bullet_damage : float
@export var big_bullet_damage : float
@export var explosive_bullet_damage : float

# Keeps track of whether the jump button is being held or not
var jumping := false

var dashing := false
var dash_cooldown_active := false

# If this is false, the current state handles all movement
var state_allows_default_move := true

# If this is false, the current state handles the animation
var state_allows_animation := true

# 1.0 is right, -1.0 is left
var look_direction := 1.0
var knockback_direction := 0.0

var recoil_direction : Vector2
var gun_direction : Vector2

# List of enemies hit with one attack. Used to make sure enemies aren't hit more than once
var hit_enemies : Array

var multiplier_bar : ProgressBar

var sword_xp := 0.0
var gun_xp := 0.0

@export var required_xp_for_bigsword : float
@export var required_xp_for_thrust : float
@export var required_xp_for_bigshoot : float
@export var required_xp_for_explosive : float

@onready var default_sprite_scale = $AnimatedSprite2D.scale

# Keeps track of if the sprite is bouncing dowm or if it is returning to its default scale during walk cycle
var sprite_bouncing_down := true

func _ready():
	multiplier_bar = get_tree().get_nodes_in_group("MultiplierBar")[0]
	$StateMachine/BigSwordAttack.required_xp = required_xp_for_bigsword
	$StateMachine/Shoot.damage = bullet_damage
	$StateMachine/BigShoot.damage = big_bullet_damage
	$StateMachine/BigShoot.required_xp = required_xp_for_bigshoot
	$StateMachine/SwordThrust.required_xp = required_xp_for_thrust
	$StateMachine/ShootExplosive.damage = explosive_bullet_damage
	$StateMachine/ShootExplosive.required_xp = required_xp_for_explosive

func _physics_process(delta):
	#print(Engine.get_frames_per_second())
	#print($DashCoolDown.is_stopped())
	if state_allows_default_move:
		# Add the gravity.
		if not is_on_floor():
			velocity.y += get_custom_gravity() * delta

		# Handle jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			$AnimatedSprite2D.scale = default_sprite_scale * Vector2(0.7, 1.3)
			jump()
		if Input.is_action_just_released("jump"):
			jumping = false
		
		# Get the input direction and handle the movement/deceleration.
		var direction = Input.get_axis("left", "right")
		if recoil_direction != Vector2.ZERO:
			velocity = recoil_direction * recoil_speed
		elif direction:
			velocity.x = direction * speed
			look_direction = direction
		#elif dashing:
			#velocity.x = look_direction * dash_speed
		else:
			velocity.x = 0.0
	#print(velocity)
	move_and_slide()
	
	if state_allows_animation:
		# Squash and stretch
		if is_on_floor() and velocity.x != 0:
			if sprite_bouncing_down:
				$AnimatedSprite2D.scale = $AnimatedSprite2D.scale.move_toward(default_sprite_scale  * Vector2(1.15, 0.85), 4*delta)
			else:
				$AnimatedSprite2D.scale = $AnimatedSprite2D.scale.move_toward(default_sprite_scale, 4*delta)
			if $AnimatedSprite2D.scale.is_equal_approx(default_sprite_scale):
				sprite_bouncing_down = true
			elif $AnimatedSprite2D.scale.is_equal_approx(default_sprite_scale * Vector2(1.15, 0.85)):
				sprite_bouncing_down = false
		else:
			$AnimatedSprite2D.scale = $AnimatedSprite2D.scale.move_toward(default_sprite_scale, 4*delta)
	
		# Animation
		if not is_on_floor():
			if get_custom_gravity() == jump_gravity:
				$AnimatedSprite2D.play("jump ascend")
			else:
				$AnimatedSprite2D.play("jump descend")
		elif velocity.x != 0:
			$AnimatedSprite2D.play("run")
		else:
			$AnimatedSprite2D.play("default")
	else:
		$AnimatedSprite2D.scale = default_sprite_scale
	
	if $StateMachine.current_state.name.to_lower() != "swordattack" and $StateMachine.current_state.name.to_lower() != "bigswordattack" and $StateMachine.current_state.name.to_lower() != "sword_thrust":
		if look_direction <= 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
	
	
	# Flip attack hitboxes
	if $StateMachine.current_state.name.to_lower() != "swordattack":
		if Input.is_action_pressed("up"):
			$SwordAttackHitbox.rotation_degrees = -90
		elif Input.is_action_pressed("down") and not is_on_floor():
			$SwordAttackHitbox.rotation_degrees = 90
		elif look_direction < 0:
			$SwordAttackHitbox.rotation_degrees = 180
		else:
			$SwordAttackHitbox.rotation_degrees = 0
	if $StateMachine.current_state.name.to_lower() != "bigswordattack":
		if Input.is_action_pressed("up"):
			$BigSwordHitbox.rotation_degrees = -90
		elif Input.is_action_pressed("down") and not is_on_floor():
			$BigSwordHitbox.rotation_degrees = 90
		elif look_direction < 0:
			$BigSwordHitbox.rotation_degrees = 180
		else:
			$BigSwordHitbox.rotation_degrees = 0
	if $StateMachine.current_state.name.to_lower() != "sword_thrust":
		if look_direction < 0:
			$SwordThrustHitbox.rotation_degrees = 180
		else:
			$SwordThrustHitbox.rotation_degrees = 0
	
	#Rotate gun
	gun_direction = Input.get_vector("left", "right", "up", "down")
	#if gun_direction.is_equal_approx(Vector2(0,1)) and is_on_floor():
		#gun_direction = Vector2(look_direction, 1)
	if gun_direction.is_equal_approx(Vector2(0,0)):
		gun_direction = Vector2(look_direction, 0)
	$GunRotator.rotation = Vector2.ZERO.angle_to_point(gun_direction)
	
	# Get xp
	$"XP Layer/SwordXP".value = sword_xp
	$"XP Layer/GunXP".value = gun_xp
	

# This is called get_custom_gravity because get_gravity is a function built into godot
func get_custom_gravity() -> float:
	if velocity.y < 0.0 and jumping or recoil_direction.is_equal_approx(Vector2(0.0, -1.0)):
		return jump_gravity
	else:
		return fall_gravity
	
	#return jump_gravity if velocity.y < 0.0 and jumping else fall_gravity

func jump():
	velocity.y = jump_velocity
	jumping = true

func hit(hit_pos):
	if $InvinviblityTimer.is_stopped():
		if hit_pos.direction_to(global_position).x >= 0:
			# This is "Greater or equal to" the default direction is right
			knockback_direction = 1.0
		else:
			knockback_direction = -1.0
		$InvinviblityTimer.start()

#func _on_dash_timer_timeout():
	#dashing = false
	#dash_cooldown_active = true
	#$DashCoolDown.start()

func big_sword_check() -> bool:
	if sword_xp >= required_xp_for_bigsword:
		return true
	else:
		return false

func sword_thrust_check() -> bool:
	if sword_xp >= required_xp_for_thrust:
		return true
	else:
		return false

func big_shoot_check() -> bool:
	if gun_xp >= required_xp_for_bigshoot:
		return true
	else:
		return false

func explosive_check() -> bool:
	if gun_xp >= required_xp_for_explosive:
		return true
	else:
		return false

func sword_attack(enemy, damage, hitbox, knockback_mult):
	hit_enemies.append(enemy)
	enemy.hit(damage * multiplier_bar.right_type_mult, Vector2.from_angle(hitbox.rotation) * knockback_mult)
	recoil_direction = Vector2.from_angle(hitbox.rotation) * -1
	if recoil_direction.is_equal_approx(Vector2(0.0, -1.0)):
		# Set recoil timer to pogo time
		$RecoilTime.wait_time = pogo_time
	else:
		# Set recoil timer to regular recoil time
		$RecoilTime.wait_time = recoil_time
	$RecoilTime.start()

func create_dash_effect(animation_time):
	var dash_silhouette = $AnimatedSprite2D.duplicate()
	get_parent().add_child(dash_silhouette)
	dash_silhouette.global_position = $AnimatedSprite2D.global_position
	await get_tree().create_timer(animation_time).timeout
	dash_silhouette.modulate.a = 0.4
	await get_tree().create_timer(animation_time).timeout
	dash_silhouette.modulate.a = 0.2
	dash_silhouette.queue_free()

func _on_sword_attack_hitbox_body_entered(body):
	if body.is_in_group("Enemy") and !hit_enemies.has(body):
		#hit_enemies.append(body)
		#body.hit(sword_attack_damage * multiplier_bar.right_type_mult, Vector2.from_angle($SwordAttackHitbox.rotation))
		#recoil_direction = Vector2.from_angle($SwordAttackHitbox.rotation) * -1
		#if recoil_direction.is_equal_approx(Vector2(0.0, -1.0)):
			## Set recoil timer to pogo time
			#$RecoilTime.wait_time = pogo_time
		#else:
			## Set recoil timer to regular recoil time
			#$RecoilTime.wait_time = recoil_time
		#$RecoilTime.start()
		sword_attack(body, sword_attack_damage, $SwordAttackHitbox, 1)

func _on_recoil_time_timeout():
	recoil_direction = Vector2.ZERO


func _on_big_sword_hitbox_body_entered(body):
	if body.is_in_group("Enemy") and !hit_enemies.has(body):
		sword_attack(body, big_sword_damage, $BigSwordHitbox, 1)


func _on_sword_thrust_hitbox_body_entered(body):
	if body.is_in_group("Enemy") and !hit_enemies.has(body):
		sword_attack(body, sword_thrust_damage, $SwordThrustHitbox, 8.5)
