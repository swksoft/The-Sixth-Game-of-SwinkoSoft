extends Node

func display_level_text(position: Vector2, level_up = false, level_down = false):
	var text = Label.new()
	
	text.global_position = position
	text.z_index = 5 # SALE AL FRENTE
	text.label_settings = LabelSettings.new()
	
	var color = "#FFF"
	text.label_settings.font_color = color
	text.label_settings.font_size = 12
	text.label_settings.outline_color = "#000"
	text.label_settings.outline_size = 2
	
	if level_up:
		color = "#44bb33"
		text.label_settings.font_color = color
		text.text = "Level Up"
	elif level_down:
		color = "#44bb33"
		text.label_settings.font_color = color
		text.text = "Level Down"
	else:
		return
	
	call_deferred("add_child", text)
	
	await text.resized
	text.pivot_offset = Vector2(text.size / 2)
	
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(
		text, "position:y", text.position.y - 5, 45
	).set_ease(tween.EASE_OUT)
	tween.tween_property(
		text, "scale", Vector2.ZERO, 0.25
	).set_ease(tween.EASE_IN).set_delay(0.75)
	
	await tween.finished
	text.queue_free()
	
func display_number(value: float, position: Vector2): 
	if value == 0:
		return
	
	var number = Label.new()
	number.global_position = position
	number.text = str(value).pad_decimals(0)
	number.z_index = 5 # SALE AL FRENTE
	number.label_settings = LabelSettings.new()
	
	var color = "#FFF"
		
	number.label_settings.font_color = color
	number.label_settings.font_size = 16
	number.label_settings.outline_color = "#000"
	number.label_settings.outline_size = 4
	
	call_deferred("add_child", number)
	
	await number.resized
	number.pivot_offset = Vector2(number.size / 2)
	
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(
		number, "position:y", number.position.y - 24, 0.45
	).set_ease(tween.EASE_OUT)
	tween.tween_property(
		number, "scale", Vector2.ZERO, 0.25
	).set_ease(tween.EASE_IN).set_delay(0.2)
	
	await tween.finished
	number.queue_free()
