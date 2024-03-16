extends Control

@onready var exit_button = $CanvasLayer/Options/VBoxButtons/ExitButton
@onready var start_button = $CanvasLayer/Options/VBoxButtons/StartButton


func _ready():
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
	TransitionLayer.change_scene("res://scenes/test_level.tscn")
