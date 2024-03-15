extends Node2D

@export var limit_flag: bool
@export var time_flag: bool
@export var time = 1
@export var trans = 1

func _ready():
	''' Datos de nivel '''
	GLOBAL.time_left = time
	GLOBAL.trans_left = trans
	''' Habilitar limite tiempo/movimientos '''
	GLOBAL.time = time_flag
	GLOBAL.trans = trans
