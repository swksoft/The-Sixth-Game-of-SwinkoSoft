extends Level

func _ready():
	GLOBAL.stop_timer()
	''' Datos de nivel '''
	GLOBAL.time_left = time
	GLOBAL.trans_left = trans
	''' Habilitar limite tiempo/movimientos '''
	GLOBAL.time = time_flag
	GLOBAL.trans = limit_flag

func next_level():
	$Node2D.visible = true
	$Player.visible = false
	var scene: String = "res://scenes/map_%s.tscn" % next_map
	TransitionLayer.change_scene("res://scenes/main_menu.tscn", 7, true)
