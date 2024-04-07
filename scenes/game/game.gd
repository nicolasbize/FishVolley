extends Node2D

signal complete

var score := Vector2(0, 0)

@export var kickoff1 : Node2D
@export var kickoff2 : Node2D
@export var water_left : Water
@export var water_right : Water
@export var limit_score := 7

@onready var score_control := $UI/ScoreControl
@onready var score_label := $UI/ScoreControl/ScoreLabel
@onready var game_timer := $GameTimer
@onready var complete_match_timer := $CompleteMatchTimer
@onready var spawns := $Spawns
@onready var fish_parent := $Fishes
@onready var win_label := $UI/WinLabel

const Ball = preload("res://scenes/ball/ball.tscn")

const Fishes = [
	preload("res://scenes/fish/fish.tscn"),
	preload("res://scenes/fish/carp.tscn"),
]

var next_kickoff_position := Vector2.ZERO
var ball : Ball

var control_option := MenuScreen.MenuOption.Exhibition
var fish_p1_index := 0
var fish_p2_index := 0

func setup(option: MenuScreen.MenuOption, char1: int, char2: int):
	control_option = option
	fish_p1_index = char1
	fish_p2_index = char2

# Called when the node enters the scene tree for the first time.
func _ready():
	water_left.connect("lost_point", on_water_left_lost_point.bind())
	water_right.connect("lost_point", on_water_right_lost_point.bind())
	game_timer.connect("timeout", on_game_timer_timeout.bind())
	complete_match_timer.connect("timeout", on_complete_match_timer.bind())
	var kickoff_positions = [kickoff1, kickoff2]
	kickoff_positions.shuffle()
	next_kickoff_position = kickoff_positions[0].position
	var fish : Fish = Fishes[fish_p1_index].instantiate()
	fish_parent.add_child(fish)
	fish.global_position = spawns.get_child(0).global_position
	fish = Fishes[fish_p2_index].instantiate()
	fish_parent.add_child(fish)
	fish.global_position = spawns.get_child(1).global_position
	if control_option == MenuScreen.MenuOption.Exhibition:
		fish.control = Fish.ControlScheme.CPU
	else:
		fish.control = Fish.ControlScheme.PlayerTwo
	GameMusic.play_track(GameMusic.Track.Gameplay)
	start_round()

func on_water_left_lost_point():
	score.y += 1
	GameState.stop_point()
	next_kickoff_position = kickoff1.position
	game_timer.start()

func on_water_right_lost_point():
	score.x += 1
	GameState.stop_point()
	next_kickoff_position = kickoff2.position
	game_timer.start()

func on_game_timer_timeout():
	if score.x == limit_score or score.y == limit_score:
		finish_match()
	else:
		start_round()
	
func start_round():
	create_ball()
	ball.position = next_kickoff_position
	update_score()
	score_control.visible = true
	GameSounds.play(GameSounds.Sound.Whistle)
	GameState.start_point(ball)

func finish_match():
	update_score()
	score_control.visible = true
	if score.x == limit_score:
		win_label.text = "Player 1 won!"
	else:
		if control_option == MenuScreen.MenuOption.Local1v1:
			win_label.text = "Player 2 won!"
		else:
			win_label.text = "CPU won!"
	win_label.visible = true
	complete_match_timer.start()

func create_ball():
	ball = Ball.instantiate()
	ball.connect("motion_started", on_ball_motion_started.bind())
	add_child(ball)
	ball.reset()

func on_ball_motion_started():
	score_control.visible = false

func update_score():
	score_label.text = str(score.x) + " - " + str(score.y)

func on_complete_match_timer():
	emit_signal("complete")
