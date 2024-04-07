extends Fish

func get_cpu_input_vector() -> Vector2:
	var x := 0.0
	var y := 0.0
	if not ball.in_play:
		return Vector2(sign(ball.position.x - position.x), sign(ball.position.y - position.y))
	else:
		if ball.position.y > position.y: # position below the ball
			y = 1
		return Vector2(sign(ball.position.x - position.x), y)
