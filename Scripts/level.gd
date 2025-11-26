extends Node2D

var enemies_killed : int
var reload : bool

func _ready():
	reload = false
	Global.level_num = name.substr(name.length() - 1).to_int()

func _process(_delta):
	if reload:
		get_tree().reload_current_scene()
