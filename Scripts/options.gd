extends CanvasLayer

func _ready():
	# Be active even when the game is paused
	process_mode = Node.PROCESS_MODE_ALWAYS
	$ReturnToGame.disabled = true
	$ReturnToGame.visible = false
	$ExitToMenu.disabled = true
	$ExitToMenu.visible = false

func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = !get_tree().paused
		$ReturnToGame.disabled = !$ReturnToGame.disabled
		$ReturnToGame.visible = !$ReturnToGame.visible
		$ExitToMenu.disabled = !$ExitToMenu.disabled
		$ExitToMenu.visible = !$ExitToMenu.visible


func _on_return_to_game_pressed():
	get_tree().paused = false
	$ReturnToGame.disabled = !$ReturnToGame.disabled
	$ReturnToGame.visible = !$ReturnToGame.visible
	$ExitToMenu.disabled = !$ExitToMenu.disabled
	$ExitToMenu.visible = !$ExitToMenu.visible


func _on_exit_to_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
