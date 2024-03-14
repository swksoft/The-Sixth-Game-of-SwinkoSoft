extends CanvasLayer

var dialogue := [
	"\"Billions must die.\""
]

@onready var animation = $Animation
@onready var dialogue_label = $DialogueLabel
@onready var timer = $Timer

func change_scene(target: String) -> void:
	%DialogueLabel.text = dialogue[0]
	
	visible = true
	animation.play("fade_in")
	print("aiya!")
	await animation.animation_finished
	animation.play("dialogue")
	await animation.animation_finished
	
	get_tree().change_scene_to_file(target)
	
	animation.play("fade_out")
	await animation.animation_finished
	#timer.start()
	
	#TransitionLayer.change_scene(target)
	
	#TransitionLayer.get_tree().change_scene_to_file(target)
	
func _on_timer_timeout():
	animation.play("fade_out")
	await animation.animation_finished
	visible = false
