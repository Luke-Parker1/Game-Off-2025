extends Control

func _ready():
	if Global.level_num == Global.last_level:
		$NextLevel.visible = false
		$NextLevel.disabled = true
	else:
		$NextLevel.visible = true
		$NextLevel.disabled = false
	if Global.best_times[Global.level_num - 1] == 0.0:
		$TimeInfo.text = str("Time: ", Global.format_time(Global.time), "\nFirst Clear!")
		Global.best_times[Global.level_num - 1] = Global.time
	elif Global.time < Global.best_times[Global.level_num - 1]:
		$TimeInfo.text = str("Time: ", Global.format_time(Global.time), "\nNew best time!")
		Global.best_times[Global.level_num - 1] = Global.time
	else:
		$TimeInfo.text = str("Time: ", Global.format_time(Global.time), "\nBest Time: ", Global.format_time(Global.best_times[Global.level_num - 1]))

func _on_next_level_pressed():
	get_tree().change_scene_to_file("res://Scenes/level_" +str(Global.level_num + 1)+ ".tscn")


func _on_replay_level_pressed():
	get_tree().change_scene_to_file("res://Scenes/level_" +str(Global.level_num)+ ".tscn")
