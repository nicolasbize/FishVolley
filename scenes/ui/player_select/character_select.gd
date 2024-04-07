extends Control

@onready var fish_texture := $TextureRect3/ColorRect/FishTexture
@onready var stat_accel := $TextureRect3/ColorRect/StatAccel
@onready var stat_speed := $TextureRect3/ColorRect/StatSpeed
@onready var stat_strength := $TextureRect3/ColorRect/StatStrength
@onready var button_next := $ButtonNext
@onready var button_prev := $ButtonPrev

const char_textures := [
	preload("res://scenes/fish/fish.png"),
	preload("res://scenes/fish/carp.png"),
]

const stat_textures = [
	preload("res://scenes/ui/player_select/rate-1.png"),
	preload("res://scenes/ui/player_select/rate-2.png"),
	preload("res://scenes/ui/player_select/rate-3.png"),
]

const char_accels = [1, 0]
const char_speeds = [0, 1]
const char_strenghts = [1, 1]

var current_index = 0

func _ready():
	refresh_ui()
	button_next.connect("pressed", on_next_press.bind())
	button_prev.connect("pressed", on_prev_press.bind())

func on_next_press():
	if current_index < char_textures.size():
		current_index += 1
		GameSounds.play(GameSounds.Sound.MenuNav)
		refresh_ui()

func on_prev_press():
	if current_index > 0:
		current_index -= 1
		GameSounds.play(GameSounds.Sound.MenuNav)
		refresh_ui()

func refresh_ui():
	fish_texture.texture = char_textures[current_index]
	stat_accel.texture = stat_textures[char_accels[current_index]]
	stat_speed.texture = stat_textures[char_speeds[current_index]]
	stat_strength.texture = stat_textures[char_strenghts[current_index]]
	button_prev.visible = current_index > 0
	button_next.visible = current_index < char_textures.size() - 1
