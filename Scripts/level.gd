extends Node2D

var enemies_killed : int
var reload : bool

func _ready():
	reload = false

func _process(_delta):
	if reload:
		get_tree().reload_current_scene()
