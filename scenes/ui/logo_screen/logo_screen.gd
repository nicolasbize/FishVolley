extends Node2D

signal finished

@export var duration_appearance := 3.0

@onready var animation_player := $CanvasLayer/AnimationPlayer

var can_skip := false
var time_appeared := -1

func _process(delta):
	if can_skip and (is_trying_to_skip() or (Time.get_ticks_msec() - time_appeared > duration_appearance * 1000)):
		can_skip = false
		animation_player.play("fade_logo_out")

func on_logo_appeared():
	can_skip = true
	time_appeared = Time.get_ticks_msec()

func on_logo_disappeared():
	emit_signal("finished")

func is_trying_to_skip():
	return Input.is_action_just_pressed("accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)
