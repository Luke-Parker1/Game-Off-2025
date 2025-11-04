extends ProgressBar

# Keeps track of if the value should be counting up or down
var reversed := false

# Multiplier for weapons assigned to the left side (CHOOSE WHAT THIS IS LATER)
var left_type_mult : float

# Multiplier for weapons assigned to the right side (CHOOSE WHAT THIS IS LATER)
var right_type_mult : float

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Keep bar moving up and down
	if !reversed:
		value += delta
	elif reversed:
		value -= delta
	if value >= max_value or value <= min_value:
		reversed = !reversed
	
	if value > max_value/2:
		left_type_mult = (value - max_value/2)/(max_value/2)
		right_type_mult = 0
	else:
		left_type_mult = 0
		right_type_mult = (max_value/2 - value)/(max_value/2)
	#left_type_mult = value/max_value
	#right_type_mult = (max_value - value)/max_value
	#print("Left Weapon Damage Multiplier: ", left_type_mult)
	#print("Right Weapon Damage Multiplier: ", right_type_mult)
	
