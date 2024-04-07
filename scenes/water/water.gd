class_name Water
extends Node2D

signal lost_point

@onready var countdown_label := $CountdownLabel
@onready var ball_detector_area := $BallDetectorArea
@onready var water_sprite := $WaterSprite
@onready var water_depoison_timer := $WaterDepoisonTimer

@export var good_water : Texture2D
@export var bad_water : Texture2D
@export var ball_detector : BallDetector
@export var limit_time := 7

var poisoned := false
var ball : Ball

func _init():
	GameState.connect("point_started", on_point_started.bind())
	GameState.connect("point_stopped", on_point_stopped.bind())

func on_point_started(target:Ball):
	ball = target

func on_point_stopped():
	ball = null

func _ready():
	countdown_label.visible = false
	ball_detector.connect("on_ball_enter", on_ball_enter.bind())
	ball_detector.connect("on_ball_leave", on_ball_leave.bind())
	ball_detector.connect("on_ball_second", on_ball_here_too_long.bind())
	water_depoison_timer.connect("timeout", on_water_depoison_timer_timeout.bind())

func on_ball_enter():
	countdown_label.text = ""
	countdown_label.visible = true

func on_ball_leave():
	countdown_label.visible = false
	depoison_water()

func on_ball_here_too_long(time_spent):
	if limit_time - time_spent <= 0 and not poisoned:
		poison_water()
	elif limit_time - time_spent < 4: 
		countdown_label.text = str(limit_time - time_spent)

func poison_water():
	poisoned = true
	water_sprite.texture = bad_water
	countdown_label.visible = false

func depoison_water():
	poisoned = false
	water_sprite.texture = good_water
	
func _process(delta):
	if ball != null and poisoned and contains_ball():
		destroy_ball()

func destroy_ball():
	if ball != null and ball.in_play:
		ball.destroy_in_place()
		ball = null
		water_depoison_timer.start()
		emit_signal("lost_point")
	else:
		print("tried to destroy ball")

func on_water_depoison_timer_timeout():
	depoison_water()

func contains_ball():
	return ball_detector_area.get_overlapping_bodies().size() > 0

