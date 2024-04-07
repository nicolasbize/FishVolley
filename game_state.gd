extends Node

enum GameMode {}

signal point_stopped
signal point_started

var ball : Ball

func start_point(target: Ball):
	ball = target
	emit_signal("point_started", ball)

func stop_point():
	ball = null
	emit_signal("point_stopped")
