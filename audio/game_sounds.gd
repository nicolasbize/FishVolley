extends Node

enum Sound {MenuNav, MenuSelect, Splash, Poof, Hit, Whistle}

var sound_map = {}

func _ready():
	sound_map = {
		Sound.MenuNav: $MenuNav,
		Sound.MenuSelect: $MenuSelect,
		Sound.Splash: $Splash,
		Sound.Poof: $Poof,
		Sound.Hit: $Hit,
		Sound.Whistle: $Whistle,
	}

func play(sound: Sound, alter_pitch: bool = false) -> void:
	if sound_map[sound] is SoundPool:
		sound_map[sound].play_random_sound(alter_pitch)
	else:
		sound_map[sound].play_sound(alter_pitch)

func stop(sound: Sound):
	sound_map[sound].stop()
