extends Level

func next_level():
	$Node2D.visible = true
	$Player.visible = false
	var scene: String = "res://scenes/map_%s.tscn" % next_map
	TransitionLayer.change_scene("res://scenes/main_menu.tscn", 7, true)
