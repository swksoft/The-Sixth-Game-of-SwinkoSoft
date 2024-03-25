extends CanvasLayer

signal level_completed

''' Seleccción de diálogos '''
var dialogue := [
	"\"Well, I'm here. What did I have to do?\"", # # MAP 00
	"\"Oh, yeah. Kill Anima.\"",  #01
	"\"Better invest in ghost protection.\"", # MAP 02
	"\"I can possess them without any difficulties.\"", # MAP 03
	"\"They already know I'm here, I'd better stop time.\"", # MAP 04
	"\"Satisfactory.\"", # MAP 05
	"\"Piece of cake.\"", # MAP 06
	"\" C'mon Step it Up! \"", # MAP 07
	"\"Guess I've never had a chance...\"",  # MAP 08
]

@onready var animation = $Animation
@onready var dialogue_label = $DialogueLabel

func fast_change_scene(d_number = 0, dialog_see = false):
	GLOBAL.during_cutscene = true
	
	''' Animación Fade-in'''
	visible = true
	animation.play("fade_in")
	await animation.animation_finished
	
	if dialog_see:
		''' Selección de diálogo '''
		%DialogueLabel.text = dialogue[d_number]
		animation.play("dialogue")
		await animation.animation_finished
	
	''' Cambio de escena '''
	emit_signal("level_completed")
	
	''' Animación Fade-out '''
	animation.play("fade_out")
	await animation.animation_finished

func change_scene(target: String, d_number = 0, dialog_see = false) -> void:
	GLOBAL.during_cutscene = true
	
	''' Animación Fade-in'''
	visible = true
	animation.play("fade_in")
	await animation.animation_finished
	
	if dialog_see:
		''' Selección de diálogo '''
		%DialogueLabel.text = dialogue[d_number]
		animation.play("dialogue")
		await animation.animation_finished
	
	''' Cambio de escena '''
	#emit_signal("level_completed")
	get_tree().change_scene_to_file(target)
	
	''' Animación Fade-out '''
	animation.play("fade_out")
	await animation.animation_finished
	#timer.start()
	
	#TransitionLayer.change_scene(target)
	
	#TransitionLayer.get_tree().change_scene_to_file(target)

func reset_scene() -> void:
	GLOBAL.during_cutscene = true
	animation.speed_scale = 24
	animation.play("fade_in")
	await animation.animation_finished
	get_tree().reload_current_scene.call_deferred()
	animation.play("fade_out")
	await animation.animation_finished
	animation.speed_scale = 1
