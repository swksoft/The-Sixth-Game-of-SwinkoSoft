extends Control

signal game_over
signal level_clear

@export var hide_data: bool = false

var alarm = true
var transition = true
@export var no_enemy_count = false
var body_count = 0

@onready var player = get_parent().get_node("Player")
@onready var enemies = get_parent().get_node("Enemies")
@onready var animation = $Animation
@onready var alarm_sfx = $AlarmSFX
@onready var enemie_group = enemies.get_children()
@onready var pause_menu = get_parent().get_node("PauseMenu")

func _ready():
	if hide_data:
		%DataBox.visible = false
		GLOBAL.timer_on = false
	else:
		%DataBox.visible = true
		GLOBAL.timer_on = true
	
	''' Cuenta todos los enemigos en pantalla '''
	%GameOver.visible = false
	body_count = 0
	GLOBAL.enemies_left = enemie_group.size()
	if GLOBAL.enemies_left == 0:
		no_enemy_count = true
	GLOBAL.combat_count = 0

func alert_mode():
	pause_menu.queue_free()
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
	''' Activar bandera una vez '''
	'''
	if transition:
		transition = false
		
		%DataBox.visible = false
		
		await get_tree().create_timer(1.0).timeout
		
		Cambia de escena con transición
		TransitionLayer.change_scene("res://scenes/test_level.tscn")
		'''
func _process(delta):
	if hide_data:
		return
	''' Gestor de HUD: '''
	%StepsLabel.text = str(GLOBAL.time_left)
	if !no_enemy_count:
		%KillsLabel.text = str(body_count) + "/" + str(GLOBAL.enemies_left)
	
	if GLOBAL.trans_left <= 0:
		%TransLabel.add_theme_color_override("font_color", Color("ff0000"))
	else:
		%TransLabel.add_theme_color_override("font_color", Color("ffffff"))
	%TransLabel.text = str(GLOBAL.trans_left)
	if GLOBAL.timer_on:
		GLOBAL.time_count += delta
		var mins = fmod(GLOBAL.time_count, 60*60) / 60
		var mil = fmod (GLOBAL.time_count, 1000)
		
		var mil_formatted = str(mil).pad_decimals(2)
		
		var time_passed = "%02d : %s" % [mins, mil_formatted]
		
		%TimeLabel.text = str(time_passed)
	
	''' Si te quedas sin movimientos: '''
	if GLOBAL.time_left <= 0:
		alert_mode()
		emit_signal("game_over")
	
	''' Si matas a todos los enemigos: '''
	if body_count >= GLOBAL.enemies_left and !no_enemy_count:
		emit_signal("game_over")
		win()

func _on_restart_button_pressed():
	TransitionLayer.reset_scene()
	#get_tree().reload_current_scene.call_deferred()

func _on_player_enemy_down():
	body_count += 1
