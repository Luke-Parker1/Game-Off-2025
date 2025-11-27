extends CanvasLayer

func _ready():
	Global.time = 0

func _process(delta):
	Global.time += delta
	
	$Label.text = Global.format_time(Global.time)

#func update_ui():	
	#var decimal = str(Global.time - floor(Global.time)).substr(1,3)
	#var seconds = int(floor(Global.time)) % 60
	#var minutes = int(floor(Global.time) / 60)
	##print("%02d" %minutes, ":", seconds + decimal)
	#var formatted_time : String
	#if minutes > 0:
		#formatted_time = str(minutes, ":", "%02d" %seconds, decimal)
	#else:
		#formatted_time = str("%02d" %seconds, decimal)
	#
	#$Label.text = formatted_time
