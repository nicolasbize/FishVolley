extends Sprite2D

@export var ball: Ball

var initial_position_y := 0

func _ready():
	initial_position_y = global_position.y

func _process(delta):
	visible = ball.is_in_air()
	position.x = ball.position.x
	scale.x = clampf(max(1, ball.position.y) / 100.0, 0.2, 1.0)
