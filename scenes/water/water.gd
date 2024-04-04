class_name Water
extends Node2D

@onready var countdown_label := $CountdownLabel
@onready var sprite := $Sprite2D
@onready var ball_detector_area := $BallDetectorArea

@export var ball_detector : BallDetector
@export var limit_time := 7

func _ready():
	countdown_label.visible = false
	ball_detector.connect("on_ball_enter", on_ball_enter.bind())
	ball_detector.connect("on_ball_leave", on_ball_leave.bind())
	ball_detector.connect("on_ball_second", on_ball_here_too_long.bind())

func on_ball_enter():
	countdown_label.text = ""
	countdown_label.visible = true

func on_ball_leave():
	countdown_label.visible = false

func on_ball_here_too_long(time_spent):
	if limit_time - time_spent <= 0:
		
		countdown_label.visible = false
	elif limit_time - time_spent < 4: 
		countdown_label.text = str(limit_time - time_spent)

func contains_ball():
	return ball_detector_area.get_overlapping_bodies().length() > 0

