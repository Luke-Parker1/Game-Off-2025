extends Node

var level_num := 0
var last_level := 8
var best_times: Array

# Speedrun timer
var time := 0.0

func _ready():
	for i in last_level:
		best_times.append(0.0)

func format_time(timer) -> String:
	var decimal = str(timer - floor(timer)).substr(1,3)
	var seconds = int(floor(timer)) % 60
	var minutes = int(floor(timer) / 60)
	var formatted_time : String
	if minutes > 0:
		formatted_time = str(minutes, ":", "%02d" %seconds, decimal)
	else:
		formatted_time = str("%02d" %seconds, decimal)
	
	return formatted_time
