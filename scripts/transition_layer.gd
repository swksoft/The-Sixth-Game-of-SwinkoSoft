extends CanvasLayer

@onready var animation = $Animation
@onready var dialogue_label = $DialogueLabel
@onready var timer = $Timer

var dialogue := [
	"Texto de ejemplo."
]

func change_scene(target: String) -> void:
	visible = true
	animation.play("fade_in")
	await animation.animation_finished
	animation.play("dialogue")
	await animation.animation_finished
	#timer.start()
	
	#TransitionLayer.change_scene(target)
	get_tree().change_scene_to_file(target)
	#TransitionLayer.get_tree().change_scene_to_file(target)
	
func _on_timer_timeout():
	animation.play("fade_out")
	await animation.animation_finished
	visible = false
