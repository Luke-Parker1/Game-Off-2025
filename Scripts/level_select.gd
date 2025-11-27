extends Control

var current_level = 1

func _ready():
	for i in get_children():
		if i.name.contains("Level"):
			i.pressed.connect(_on_level_pressed.bind(int(i.name.substr(i.name.length() - 1))))

func _process(_delta):
	if Global.best_times[current_level - 1] == 0:
		$Label.text = str("Level ", current_level, "\nBest Time: --:--")
	else:
		$Label.text = str("Level ", current_level, "\nBest Time: ", Global.format_time(Global.best_times[current_level - 1]))

func _on_level_pressed(num):
	current_level = num


func _on_play_pressed():
	get_tree().change_scene_to_file("res://Scenes/level_" +str(current_level)+ ".tscn")
