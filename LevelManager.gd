extends Node

var levels = []
var current_level_index = 0
var current_level_instance = null

func _ready():
	var dir = "res://scenes/maps/"
	var dir_maps = DirAccess.open(dir)
	
	if dir_maps:
		dir_maps.list_dir_begin()
		var file_name = dir_maps.get_next()
		while file_name != "":
			#if dir_maps.current_is_dir():
				#print("Found directory: " + file_name)
			#else:
				#print("Found file: " + file_name)
			if file_name.ends_with(".tscn"):
				levels.append(file_name.get_basename().get_file())
				#print("Found map: " + file_name)
				
				file_name = dir_maps.get_next()
			
			load_next_level()
	else:
		print("Error")
	
	print(levels)
	
	#for current_map in levels:
		#print("MAPA ACTUAL: ", current_map)
		#load_level(current_map)

func load_next_level():
	if current_level_index < levels.size():
		if current_level_instance != null:
			#current_level_instance.queue_free().#call_throttled()
			#call_deferred("queue_free", current_level_instance)
			current_level_instance.call_deferred('free')

		var selected_scene = "res://scenes/maps/" + levels[current_level_index] + ".tscn"
		var level_scene = load(selected_scene)
		current_level_instance = level_scene.instantiate()

		current_level_instance.level_completed.connect(_on_level_completed)

		#add_child(current_level_instance)
		call_deferred("add_child", current_level_instance)
		
	else:
		print("¡Todos los niveles han sido completados!")

#func load_next_level():
	#if current_level_index < levels.size():
		#if current_level_instance != null:
			#current_level_instance.queue_free()
		#
		#var selected_scene = "res://scenes/maps/" + levels[current_level_index] + ".tscn"
		##print(selected_scene)
		#var level_scene = load(selected_scene)
		#var level_instance = level_scene.instantiate()
		#
		#
		#level_instance.level_completed.connect(_on_level_completed)
#
		#add_child(level_instance)
	#else:
		#print("¡Todos los niveles han sido completados!")
		#get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

#func _ready():
	#var maps_dir = "res://scenes/maps/"
	#var maps_directory = DirAccess.open(maps_dir)
	#
	#var levels = []
	#
	#while maps_directory.get_next() != "":
		#var file_name = maps_directory.get_file()
		#if file_name.ends_with(".tscn"):
			#levels.append(file_name.get_basename().get_file())
	#
	#for current_map in levels:
		#print(current_map)
		#load_level(current_map)
#
func load_level(level_name):
	print(level_name)
	var selected_scene = "res://scenes/maps/" + level_name + ".tscn"
	var level_scene = load(selected_scene)
	var level_instance = level_scene.instantiate()
	#get_parent().add_child(level_instance)
	
	get_tree().change_scene_to_file(level_scene)

func _on_level_completed():
	print("pico")
	current_level_index += 1
	load_next_level()
