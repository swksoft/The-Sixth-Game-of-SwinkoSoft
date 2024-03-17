extends Node

var current_track = ""
var bus
@export var music_track = "" # (String, FILE, "*.ogg")

func _ready():
	bus = AudioServer.get_bus_index($Track.bus)
	if music_track != "":
		Music.play(music_track)
	pass

func play(stream):
	if current_track == "a":
		$B.stream = load(stream)
		current_track = "b"
	else:
		$A.stream = load(stream)
		current_track = "a"

