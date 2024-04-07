class_name BallShadow
extends Sprite2D

@export var ball: Ball

var initial_position_y := 0

func _init():
	GameState.connect("point_started", on_point_started.bind())
	GameState.connect("point_stopped", on_point_stopped.bind())

func on_point_started(target:Ball):
	ball = target

func on_point_stopped():
	ball = null

func _ready():
	initial_position_y = global_position.y

func _process(delta):
	if ball == null:
		visible = false
	else:
		visible = ball.is_in_air()
		position.x = ball.position.x
		scale.x = clampf(max(1, ball.position.y) / 100.0, 0.2, 1.0)
