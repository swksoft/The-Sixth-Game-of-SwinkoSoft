extends Node2D
class_name Level

var time_left = time

signal level_completed

@export var time_flag: bool
@export var limit_flag: bool
@export var time: int = 1
@export var trans: int = 1
@export var next_map : String = "01"
@export_range(0,8) var dialog: int = 0

func current_level():
	pass

func next_level():
	#TransitionLayer.fast_change_scene()
	''' fade in '''
	''' level_completed '''
	#emit_signal("level_completed")
	#var scene: String = "res://scenes/map_%s.tscn" % next_map
	
	#TransitionLayer.change_scene(scene, dialog, true)

func _ready():
	''' fade out'''
	
	current_level()
	
	GLOBAL.during_cutscene = false
	''' Datos de nivel '''
	GLOBAL.time_left = time
	GLOBAL.trans_left = trans
	''' Habilitar limite tiempo/movimientos '''
	GLOBAL.time = time_flag
	GLOBAL.trans = limit_flag
	
	GLOBAL.during_game_over = false

func _on_hud_level_clear():
	next_level()

func _on_player_instant_win():
	next_level()

func _on_area_2d_area_entered(area):
	GLOBAL.during_cutscene = true
	var player = area.get_parent().get_parent()
	if player == null || !player.is_in_group("player"): return
	player.current_state = 2
	next_level()
