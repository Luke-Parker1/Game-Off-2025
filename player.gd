extends CharacterBody2D

@export var speed := 300.0
@export var dash_speed := 500.0

@export var jump_height : float
@export var jump_time_to_peak : float
@export var jump_time_to_descent : float

@onready var jump_velocity : float = ((2.0*jump_height)/jump_time_to_peak) * -1.0
@onready var jump_gravity : float = ((-2.0*jump_height)/(jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity : float = ((-2.0*jump_height)/(jump_time_to_descent * jump_time_to_descent)) * -1.0

# Keeps track of whether the jump button is being held or not
var jumping := false

var dashing := false
var dash_cooldown_active := false

# If this is false, the current state handles all movement
var state_allows_default_move := true

# 1.0 is right, -1.0 is left
var look_direction := 1.0
var knockback_direction := 0.0

var sword_hitbox_startpos : float

func _ready():
	sword_hitbox_startpos = $SwordAttackHitbox.position.x

func _physics_process(delta):
	#print($DashCoolDown.is_stopped())
	if state_allows_default_move:
		# Add the gravity.
		if not is_on_floor():
			velocity.y += get_custom_gravity() * delta

		# Handle jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			jump()
		if Input.is_action_just_released("jump"):
			jumping = false
		
		# Handle Dash
		#if Input.is_action_just_pressed("dash") and !dashing and !dash_cooldown_active:
			#dashing = true
			#velocity.y = 0
			#$DashTimer.start()
		
		# Get the input direction and handle the movement/deceleration.
		var direction = Input.get_axis("left", "right")
		if direction:
			velocity.x = direction * speed
			look_direction = direction
		#elif dashing:
			#velocity.x = look_direction * dash_speed
		else:
			velocity.x = 0.0
	#print(velocity)
	move_and_slide()
	
	# Flip attack hitboxes
	$SwordAttackHitbox.position.x = sword_hitbox_startpos * look_direction

# This is called get_custom_gravity because get_gravity is a function built into godot
func get_custom_gravity() -> float:
	return jump_gravity if velocity.y < 0.0 and jumping else fall_gravity

func jump():
	velocity.y = jump_velocity
	jumping = true


#func _on_dash_timer_timeout():
	#dashing = false
	#dash_cooldown_active = true
	#$DashCoolDown.start()
