class_name Ball
extends RigidBody2D

signal motion_started

@onready var air_detector := $AirDetector

const Explosion := preload("res://scenes/explosion/Explosion.tscn")

var in_play := false

func reset():
	in_play = false
	gravity_scale = 0.0
	linear_velocity = Vector2.ZERO
	angular_velocity = 0.0

func start_motion():
	in_play = true
	gravity_scale = .1
	angular_velocity = randf_range(1.0, 10.0)
	emit_signal("motion_started")

func is_in_air() -> bool:
	return air_detector.get_overlapping_areas().size() > 0

func destroy_in_place() -> void:
	var explosion = Explosion.instantiate()
	get_parent().add_child(explosion)
	explosion.global_position = global_position
	queue_free()
