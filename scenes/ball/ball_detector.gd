class_name BallDetector
extends Node2D

@onready var area := $Area2D

signal on_ball_enter
signal on_ball_leave
signal on_ball_second(time)

var entry_timestamp := 0
var was_ball_inside := false
var nb_seconds_present := 0

func _process(delta):
	if not was_ball_inside and contains_ball():
		was_ball_inside = true
		entry_timestamp = Time.get_ticks_msec()
		nb_seconds_present = 0
		emit_signal("on_ball_enter")
	elif was_ball_inside and not contains_ball():
		was_ball_inside = false
		emit_signal("on_ball_leave")
	elif was_ball_inside and contains_ball():
		if (Time.get_ticks_msec() - entry_timestamp) > 1000:
			entry_timestamp = Time.get_ticks_msec()
			nb_seconds_present += 1
			emit_signal("on_ball_second", nb_seconds_present)

func contains_ball() -> bool:
	return area.get_overlapping_bodies().size() > 0
