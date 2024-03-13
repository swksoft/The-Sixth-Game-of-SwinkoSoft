extends Control

signal game_over

var alarm = true

@onready var player = get_parent().get_node("Player")
@onready var enemies = get_parent().get_node("Enemies")
@onready var animation = $Animation
@onready var alarm_sfx = $AlarmSFX

func alert_mode():
	var enemie_group = enemies.get_children()
	for i in enemie_group:
		pass
		#alert_mode()
	
	animation.play("gamer_over")
	
	%VBoxContainer.visible = true
	
	if alarm:
		alarm = false
		alarm_sfx.play()
	
func _process(delta):
	%TimeLabel.text = "Time Left: "+ str(GLOBAL.time_left)
	
	if GLOBAL.time_left <= 0:
		emit_signal("game_over")
		alert_mode()

func _on_restart_button_pressed():
	get_tree().reload_current_scene.call_deferred()
