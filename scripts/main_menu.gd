extends Control

@onready var exit_button = $CanvasLayer/Options/VBoxButtons/ExitButton
@onready var start_button = $CanvasLayer/Options/VBoxButtons/StartButton

func _ready():
	''' BEST TIME LOAD '''
	var time_record = GLOBAL.load_best_time()
	var mins = fmod(time_record, 60*60) / 60
	var mil = fmod (time_record, 1000)
	var mil_formatted = str(mil).pad_decimals(2)
	var time_show = "%02d : %s" % [mins, mil_formatted]
	
	if time_record != 0.00:
		%BestTimeLabel.text = "Best Time: "
		%TimeLabel.text = str(time_show)
	
	''' BUTTONS '''
	start_button.grab_focus()
	
	match OS.get_name():
		"Windows":
			pass
		"macOS":
			pass
		"Linux", "FreeBSD", "NetBSD", "OpenBSD", "BSD":
			pass
		"Android":
			exit_button.disabled = true
		"iOS":
			exit_button.disabled = true
		"Web":
			exit_button.disabled = true

func _on_exit_button_pressed():
	get_tree().quit()

func _on_start_button_pressed():
	GLOBAL.time_count = 0.0
	#TransitionLayer.change_scene("res://scenes/map_01.tscn", false)
	TransitionLayer.change_scene("res://scenes/level_manager.tscn", false)

func _on_button_pressed():
	Music.play_music(load("res://assets/music/04. Nuclear Mutation.mp3"))
	GLOBAL.time_count = 0.0
	TransitionLayer.change_scene("res://scenes/map_05.tscn", false)
