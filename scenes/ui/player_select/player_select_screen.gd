extends Node2D

signal back
signal start_game(setup, fish1, fish2)

@onready var play_button := $CanvasLayer/TextureRect/PlayButton
@onready var back_button := $CanvasLayer/TextureRect/BackButton
@onready var char1_select := $CanvasLayer/TextureRect/CharacterSelect
@onready var char2_select := $CanvasLayer/TextureRect/CharacterSelect2
@onready var player_two_label := $CanvasLayer/TextureRect/PlayerTwoLabel
@onready var controls_2_texture := $CanvasLayer/TextureRect/ControlsPlayerTwoTexture

var current_setup := MenuScreen.MenuOption.Exhibition

func initialize_screen(menu_option: MenuScreen.MenuOption):
	current_setup = menu_option

func _ready():
	play_button.connect("click", on_play_pressed.bind())
	back_button.connect("click", on_back_pressed.bind())
	if current_setup == MenuScreen.MenuOption.Exhibition:
		player_two_label.text = "CPU"
		controls_2_texture.visible = false
	

func on_play_pressed():
	emit_signal("start_game", current_setup, char1_select.current_index, char2_select.current_index)

func on_back_pressed():
	emit_signal("back")
