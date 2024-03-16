extends CanvasLayer

''' Seleccción de diálogos '''
var dialogue := [
	"\"Well, I'm here. What did I have to do?\"",
	"\"Oh, yeah. Kill Anima.\"",
	"\"You should have invested in security against ghosts.\""
]

@onready var animation = $Animation
@onready var dialogue_label = $DialogueLabel

func change_scene(target: String, d_number = 0) -> void:
	''' Selección de diálogo '''
	%DialogueLabel.text = dialogue[d_number]
	
	''' Animación Fade-in'''
	visible = true
	animation.play("fade_in")
	await animation.animation_finished
	
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
	animation.speed_scale = 24
	animation.play("fade_in")
	await animation.animation_finished
	get_tree().reload_current_scene.call_deferred()
	animation.play("fade_out")
	await animation.animation_finished
	animation.speed_scale = 1
