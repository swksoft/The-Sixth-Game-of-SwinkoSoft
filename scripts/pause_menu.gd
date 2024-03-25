extends Control

@onready var animation = $AnimationPlayer

func pause():
	get_tree().paused = true
	animation.play("open")
	
func resume():
	animation.play_backwards("open")
	await animation.animation_finished
	get_tree().paused = false

func quit():
	get_tree().paused = false
	Music.stop_music()
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func menu_activate():
	if Input.is_action_just_pressed("pause") and !get_tree().paused and !GLOBAL.during_cutscene and !GLOBAL.during_game_over:
		pause()
	elif Input.is_action_just_pressed("pause") and get_tree().paused and !GLOBAL.during_cutscene:
		resume()
	elif Input.is_action_just_pressed("enter") and get_tree().paused and !GLOBAL.during_cutscene:
		quit()

func _process(_delta):
	menu_activate()
