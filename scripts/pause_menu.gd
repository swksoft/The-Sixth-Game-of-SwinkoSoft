extends Control

@onready var animation = $AnimationPlayer

func pause():
	get_tree().paused = true
	animation.play("open")
	
func resume():
	animation.play_backwards("open")
	await animation.animation_finished
	get_tree().paused = false

func menu_activate():
	if Input.is_action_just_pressed("pause") and !get_tree().paused and !GLOBAL.during_cutscene:
		pause()
	elif Input.is_action_just_pressed("pause") and get_tree().paused and !GLOBAL.during_cutscene:
		resume()

func _process(_delta):
	menu_activate()
