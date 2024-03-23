extends Level

func save_time():
	var new_time = GLOBAL.time_count
	GLOBAL.save_best_time(new_time)

func _ready():
	GLOBAL.during_cutscene = false
	GLOBAL.stop_timer()
	print(GLOBAL.time_count)
	''' Datos de nivel '''
	GLOBAL.time_left = time
	GLOBAL.trans_left = trans
	''' Habilitar limite tiempo/movimientos '''
	GLOBAL.time = time_flag
	GLOBAL.trans = limit_flag
	
	''' save time '''
	

func next_level():
	save_time()
	
	$Node2D.visible = true
	$Player.visible = false
	var scene: String = "res://scenes/map_%s.tscn" % next_map
	TransitionLayer.change_scene("res://scenes/main_menu.tscn", 7, true)
