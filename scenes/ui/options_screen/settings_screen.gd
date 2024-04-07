extends Node2D

signal done

@onready var music_slider := $CanvasLayer/Container/MusicSlider
@onready var sound_slider := $CanvasLayer/Container/SoundSlider
@onready var back_button := $CanvasLayer/Container/BackButton

func _ready():
	music_slider.connect("value_changed", on_music_volume_change.bind())
	sound_slider.connect("value_changed", on_sound_volume_change.bind())
	back_button.connect("click", on_back_click.bind())

func on_music_volume_change(value):
	AudioServer.set_bus_volume_db(1, linear_to_db(value / 100.0))
	GameSounds.play(GameSounds.Sound.MenuNav)

func on_sound_volume_change(value):
	AudioServer.set_bus_volume_db(2, linear_to_db(value / 100.0))
	GameSounds.play(GameSounds.Sound.MenuNav)

func on_back_click():
	emit_signal("done")
