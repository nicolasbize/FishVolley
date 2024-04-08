extends Control

@onready var button_next := $ButtonNext
@onready var button_prev := $ButtonPrev
@onready var difficulty_level_tex := $DifficultyLevel

const ratings = [
	preload("res://scenes/ui/player_select/rate-1.png"),
	preload("res://scenes/ui/player_select/rate-2.png"),
	preload("res://scenes/ui/player_select/rate-3.png"),
	preload("res://scenes/ui/player_select/rate-4.png"),
	preload("res://scenes/ui/player_select/rate-5.png"),
]

var current_index := 2

func _ready():
	refresh_ui()
	button_next.connect("pressed", on_next_press.bind())
	button_prev.connect("pressed", on_prev_press.bind())

func on_next_press():
	if current_index < ratings.size() - 1:
		current_index += 1
		GameSounds.play(GameSounds.Sound.MenuNav)
		refresh_ui()

func on_prev_press():
	if current_index > 0:
		current_index -= 1
		GameSounds.play(GameSounds.Sound.MenuNav)
		refresh_ui()

func refresh_ui():
	difficulty_level_tex.texture = ratings[current_index]
	button_prev.visible = current_index > 0
	button_next.visible = current_index < ratings.size() - 1
