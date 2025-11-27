extends Control


func _on_play_pressed():
	get_tree().change_scene_to_file("res://Scenes/level_select.tscn")


func _on_best_times_pressed():
	get_tree().change_scene_to_file("res://Scenes/best_times.tscn")


func _on_how_to_play_pressed():
	get_tree().change_scene_to_file("res://Scenes/how_to_play.tscn")
