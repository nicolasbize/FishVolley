class_name Fish
extends CharacterBody2D

enum PlayerNumber {One, Two, CPU1, CPU2, CPU3, CPU4, CPU5}

@export var rotation_speed := 15.0
@export var air_rotation_speed := 5.0
@export var player : PlayerNumber = PlayerNumber.One
@export var ball : Ball

@onready var air_detector := $AirDetector
@onready var water_detector := $WaterDetector

var target_angle := 0.0
var max_speed := 700.0
var acceleration := 400.0
var friction := 200.0
var in_air := false
var gravity := Vector2.DOWN * 200.0

func _physics_process(delta):
	var in_air = is_in_air()
	var input_vector := get_input_vector(player)
	if in_air:
		velocity += gravity * delta
		rotation += input_vector.x * delta * air_rotation_speed
		if input_vector.y < 0:
			velocity += Vector2.RIGHT.rotated(rotation) * delta * 30.0
	else:
		if input_vector != Vector2.ZERO:
			target_angle = input_vector.angle()
			rotation = rotate_toward(rotation, target_angle, delta * rotation_speed)
			#rotation += input_vector.x * delta * air_rotation_speed
			var target_velocity = Vector2.RIGHT.rotated(rotation) * max_speed
			velocity = velocity.move_toward(target_velocity, delta * acceleration)
		else:
			# water friction when not moving
			velocity = velocity.move_toward(Vector2.RIGHT.rotated(rotation) * 2.0, delta * friction)
			
	move_and_slide()
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is Ball:
			var target : Ball = c.get_collider()
			target.start_play()
			target.linear_velocity = Vector2.ZERO
			target.apply_central_impulse(-c.get_normal() * max(120.0 + velocity.length() / 2.0, ball.linear_velocity.length()))

func get_input_vector(player : PlayerNumber) -> Vector2:
	if (player == PlayerNumber.One):
		return Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down"))
	elif (player == PlayerNumber.Two):
		return Vector2(Input.get_axis("move_left_2", "move_right_2"), Input.get_axis("move_up_2", "move_down_2"))
	elif (player == PlayerNumber.CPU1):
		return Vector2(sign(ball.position.x - position.x), sign(ball.position.y - position.y))
	elif (player == PlayerNumber.CPU2):
		return Vector2(sign(ball.position.x - position.x), sign(ball.position.y + 12 - position.y))
	else:
		return Vector2.ZERO
			

func is_in_air() -> bool:
	return air_detector.get_overlapping_areas().size() > 0
		
