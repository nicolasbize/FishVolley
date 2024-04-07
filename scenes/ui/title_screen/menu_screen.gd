class_name MenuScreen
extends Node2D

enum MenuOption {Exhibition, Tournament, Local1v1, Settings}

signal button_click(menuoption)

@onready var exhibition_button := $CanvasLayer/Control/ExhibitionButton
@onready var tournament_button := $CanvasLayer/Control/TournamentButton
@onready var local1v1_button := $CanvasLayer/Control/Local1v1Button
@onready var settings_button := $CanvasLayer/Control/SettingsButton

func _ready():
	exhibition_button.connect("click", on_button_click.bind(MenuOption.Exhibition))
	tournament_button.connect("click", on_button_click.bind(MenuOption.Tournament))
	local1v1_button.connect("click", on_button_click.bind(MenuOption.Local1v1))
	settings_button.connect("click", on_button_click.bind(MenuOption.Settings))

func on_button_click(mode:MenuOption):
	emit_signal("button_click", mode)
