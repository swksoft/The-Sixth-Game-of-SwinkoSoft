extends Node

@onready var music = $Music
@onready var sfx = $SFX

func stop_music():
	music.playing = false

func play_music(song: Resource):
	music.stream = song
	music.play()

func play_sfx(sound):
	sfx.stream = sound
	sfx.play()
	pass
