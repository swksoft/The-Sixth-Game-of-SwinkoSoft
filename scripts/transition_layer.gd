extends CanvasLayer

''' Seleccción de diálogos '''
var dialogue := [
	"\"Well, I'm here. What did I have to do?\"", # # MAP 01
	"\"Oh, yeah. Kill Anima.\"",  #02 
	"\"Better invest in ghost protection.\"", # MAP 03
	"\"I can possess them without any difficulties.\"", # MAP 04
	"\"They already know I'm here, I'd better stop time.\"", # MAP 05
	"\"Satisfactory.\"", # MAP 06
	"\"Peace of cake.\"", # MAP 07
	"\"Guess I've never had a chance...\"" # MAP 08
]

@onready var animation = $Animation
@onready var dialogue_label = $DialogueLabel

func change_scene(target: String, d_number = 0, dialog_see = false) -> void:
	GLOBAL.during_cutscene = true
	''' Selección de diálogo '''
	
	
	''' Animación Fade-in'''
	visible = true
	animation.play("fade_in")
	await animation.animation_finished
	
	if dialog_see:
		%DialogueLabel.text = dialogue[d_number]
		''' Diálogo '''
		animation.play("dialogue")
		await animation.animation_finished
	
	''' Cambio de escena '''
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
