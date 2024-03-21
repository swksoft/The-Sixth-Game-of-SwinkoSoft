extends Node2D
class_name Level

@export var time_flag: bool
@export var limit_flag: bool
@export var time = 1
@export var trans = 1
@export var next_map : String = "01"
@export_range(0,8) var dialog: int = 0

func next_level():
	var scene: String = "res://scenes/map_%s.tscn" % next_map
	
	TransitionLayer.change_scene(scene, dialog, true)

func _ready():
	GLOBAL.during_cutscene = false
	''' Datos de nivel '''
	GLOBAL.time_left = time
	GLOBAL.trans_left = trans
	''' Habilitar limite tiempo/movimientos '''
	GLOBAL.time = time_flag
	GLOBAL.trans = limit_flag

func _on_hud_level_clear():
	print("hola2")
	next_level()

func _on_player_instant_win():
	print("hola")
	next_level()

func _on_area_2d_area_entered(area):
	GLOBAL.during_cutscene = true
	var player = area.get_parent().get_parent()
	if player == null || !player.is_in_group("player"): return
	player.current_state = 2
	next_level()
