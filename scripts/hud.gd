extends Control

signal game_over

@export var hide_data: bool = false

var alarm = true
var transition = true

@onready var player = get_parent().get_node("Player")
@onready var enemies = get_parent().get_node("Enemies")
@onready var animation = $Animation
@onready var alarm_sfx = $AlarmSFX
@onready var enemie_group = enemies.get_children()

func _ready():
	''' Cuenta todos los enemigos en pantalla para verificar enemigos en pantalla '''
	GLOBAL.enemies_left = enemie_group.size()
	GLOBAL.combat_count = 0

func alert_mode():
	''' Player no se moverá en Game Over '''
	animation.play("gamer_over")
	
	%VBoxContainer.visible = true
	
	''' Alarma en Game Over '''
	if alarm:
		alarm = false
		alarm_sfx.play()

func win():
	''' Activar bandera una vez '''
	if transition:
		transition = false
		
		%TimeLabel.visible = false
		%EnemyLabel.visible = false
		%TransLabel.visible = false
		
		await get_tree().create_timer(1.0).timeout
		
		''' Cambia de escena con transición '''
		TransitionLayer.change_scene("res://scenes/test_level.tscn")

func _process(_delta):
	if hide_data:
		return
	''' Gestor de HUD: '''
	%TimeLabel.text = "Time Left: " + str(GLOBAL.time_left)
	%EnemyLabel.text = "Enemies: " + str(GLOBAL.enemies_left)
	%TransLabel.text = "Transformations: " + str(GLOBAL.trans_left)
	
	''' Si te quedas sin movimientos: '''
	if GLOBAL.time_left <= 0:
		emit_signal("game_over")
		alert_mode()
	
	''' Si matas a todos los enemigos: '''
	if GLOBAL.enemies_left <= 0:
		emit_signal("game_over")
		win()
	
	''' Si te quedas sin transformaciones: '''
	if GLOBAL.trans_left <= 0:
		emit_signal("game_over")
		alert_mode()

func _on_restart_button_pressed():
	TransitionLayer.reset_scene()
	#get_tree().reload_current_scene.call_deferred()
