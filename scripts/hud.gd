extends Control

signal game_over

var alarm = true
var transition = true

@onready var player = get_parent().get_node("Player")
@onready var enemies = get_parent().get_node("Enemies")
@onready var animation = $Animation
@onready var alarm_sfx = $AlarmSFX
@onready var enemie_group = enemies.get_children()

func _ready():
	GLOBAL.enemies_left = enemie_group.size()

func alert_mode():
	for i in enemie_group:
		pass
		#alert_mode()
	
	animation.play("gamer_over")
	
	%VBoxContainer.visible = true
	
	if alarm:
		alarm = false
		alarm_sfx.play()

func win():
	if transition:
		transition = false
		
		%TimeLabel.visible = false
		%EnemyLabel.visible = false
		await get_tree().create_timer(1.0).timeout
		TransitionLayer.change_scene("res://scenes/test_level.tscn")

func _process(delta):
	%TimeLabel.text = "Time Left: " + str(GLOBAL.time_left)
	%EnemyLabel.text = "Enemies Left: " + str(GLOBAL.enemies_left)
	
	if GLOBAL.time_left <= 0:
		emit_signal("game_over")
		alert_mode()
	
	if GLOBAL.enemies_left <= 0:
		emit_signal("game_over")
		win()

func _on_restart_button_pressed():
	get_tree().reload_current_scene.call_deferred()
