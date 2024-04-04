class_name Ball
extends RigidBody2D

signal play_started

@onready var air_detector := $AirDetector

var in_play := false

func reset():
	in_play = false
	gravity_scale = 0.0
	linear_velocity = Vector2.ZERO
	angular_velocity = 0.0

func start_play():
	in_play = true
	gravity_scale = .1
	emit_signal("play_started")

func is_in_air() -> bool:
	return air_detector.get_overlapping_areas().size() > 0
