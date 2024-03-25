extends Control

signal game_over
signal level_clear
signal cant_transform

@export var hide_data: bool = false

var alarm = true
var transition = true
@export var no_enemy_count = false
var body_count = 0

@onready var player = get_parent().get_node("Player")
@onready var enemies = get_parent().get_node("Enemies")
@onready var animation = $Animation
@onready var alarm_sfx = $AlarmSFX
@onready var enemy_group = enemies.get_children()
@onready var pause_menu = get_parent().get_node("PauseMenu")

@onready var map_info = get_parent().get_parent().get_child(0)
@onready var steps_left = map_info.time
@onready var trans_left: int = map_info.trans
@onready var enemies_left = 0

#@onready var enemies_left = GLOBAL.enemies_left
#@onready var trans_left = GLOBAL.trans_left
#@onready var time_left = GLOBAL.time_left

func _ready():
	if trans_left <= 0:
		emit_signal("cant_transform")
	
	''' Oculta Game_over()'''
	%GameOver.visible = false
	
	''' Cuenta todos los enemigos en pantalla '''
	enemies_left = enemy_group.size()
	#GLOBAL.enemies_left = enemie_group.size()
	#if GLOBAL.enemies_left == 0:
		#no_enemy_count = true
	#GLOBAL.combat_count = 0
	
	''' Sí '''
	if hide_data:
		%DataBox.visible = false
		GLOBAL.timer_on = false
	else:
		%DataBox.visible = true
		GLOBAL.timer_on = true
		
		%StepsLabel.text = str(steps_left)
		%TransLabel.text = str(trans_left)
		%KillsLabel.text = str(body_count) + "/" + str(enemies_left)

func alert_mode():
	#pause_menu.queue_free()
	''' Player no se moverá en Game Over '''
	animation.play("gamer_over")
	
	%DataBox.visible = false
	%GameOver.visible = true
	
	''' Alarma en Game Over '''
	if alarm:
		alarm = false
		alarm_sfx.play()

func win():
	%DataBox.visible = false
	emit_signal("level_clear")
	
func _process(delta):
	if hide_data:
		return
	''' Gestor de HUD: '''
	
	if GLOBAL.timer_on:
		GLOBAL.time_count += delta
		var mins = fmod(GLOBAL.time_count, 60*60) / 60
		var mil = fmod (GLOBAL.time_count, 1000)
		
		var mil_formatted = str(mil).pad_decimals(2)
		
		var time_passed = "%02d : %s" % [mins, mil_formatted]
		
		%TimeLabel.text = str(time_passed)

func _on_restart_button_pressed():
	TransitionLayer.reset_scene()
	#get_tree().reload_current_scene.call_deferred()

func _on_player_enemy_down():
	''' KILL COUNT '''
	body_count += 1
	
	''' Si matas a todos los enemigos: '''
	if body_count >= enemies_left:
		emit_signal("game_over")
		win()
		
	%KillsLabel.text = str(body_count) + "/" + str(enemies_left)

func _on_player_player_trans():
	trans_left -= 1
	if trans_left <= 0:
		emit_signal("cant_transform")
		%TransLabel.add_theme_color_override("font_color", Color("ff0000"))
	else:
		%TransLabel.add_theme_color_override("font_color", Color("ffffff"))
	%TransLabel.text = str(trans_left)

func _on_player_player_step():
	''' Si te quedas sin movimientos: '''
	GLOBAL.time_left -= 1
	if GLOBAL.time_left <= 0:
		alert_mode()
		emit_signal("game_over")
	%StepsLabel.text = str(GLOBAL.time_left)
