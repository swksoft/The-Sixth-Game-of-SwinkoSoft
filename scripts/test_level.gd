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
	''' Datos de nivel '''
	GLOBAL.time_left = time
	GLOBAL.trans_left = trans
	''' Habilitar limite tiempo/movimientos '''
	GLOBAL.time = time_flag
	GLOBAL.trans = limit_flag

func _on_hud_level_clear():
	next_level()

func _on_player_instant_win():
	next_level()

func _on_area_2d_area_entered(area):
	next_level()
