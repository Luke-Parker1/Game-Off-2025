extends Control

func _ready():
	for i in Global.best_times.size():
		$Label.text += str("Level ", i+1, ": ")
		if Global.best_times[i] == 0:
			$Label.text += "--:--"
		else:
			$Label.text += Global.format_time(Global.best_times[i])
		$Label.text += "\n"

func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
