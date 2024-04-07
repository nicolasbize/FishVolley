class_name Fish
extends CharacterBody2D

enum ControlScheme {PlayerOne, PlayerTwo, CPU}

@export var rotation_speed := 15.0
@export var air_rotation_speed := 5.0
@export var control : ControlScheme = ControlScheme.PlayerOne
@export var max_speed := 700.0
@export var acceleration := 400.0
@export var friction := 200.0
@export var gravity := Vector2.DOWN * 200.0

@onready var air_detector := $AirDetector
@onready var water_detector := $WaterDetector

var target_angle := 0.0
var ball : Ball
var original_position := Vector2.ZERO
var cpu_next_position := Vector2.ZERO

func _init():
	if not GameState.is_connected("point_started", on_point_started.bind()):
		GameState.connect("point_started", on_point_started.bind())
	if not GameState.is_connected("point_stopped", on_point_started.bind()):
		GameState.connect("point_stopped", on_point_stopped.bind())

func _ready():
	original_position = position

func on_point_started(target:Ball):
	ball = target
	cpu_next_position = Vector2.ZERO

func on_point_stopped():
	ball = null
	cpu_next_position = Vector2.ZERO

func _physics_process(delta):
	var in_air = is_in_air()
	var input_vector := get_input_vector()
	if in_air:
		velocity += gravity * delta
		rotation += input_vector.x * delta * air_rotation_speed
		if input_vector.y < 0:
			velocity += Vector2.RIGHT.rotated(rotation) * delta * 50.0
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
			target.start_motion()
			target.linear_velocity = Vector2.ZERO
			target.apply_central_impulse(-c.get_normal() * max(120.0 + velocity.length() / 2.0, ball.linear_velocity.length()))

func get_input_vector() -> Vector2:
	if control == ControlScheme.PlayerOne:
		return Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down"))
	elif control == ControlScheme.PlayerTwo:
		return Vector2(Input.get_axis("move_left_2", "move_right_2"), Input.get_axis("move_up_2", "move_down_2")) 
	else:
		if ball != null:
			return get_cpu_input_vector()
	return Vector2.ZERO

func get_cpu_input_vector() -> Vector2:
	return Vector2(sign(ball.position.x - position.x), sign(ball.position.y - position.y))

#
	#elif (ball != null and player == PlayerNumber.CPU2):
		#if not ball.in_play:
			#return Vector2(sign(ball.position.x - position.x), sign(ball.position.y - position.y))
		#else:
			#if ball.position.y > position.y: # position below the ball
				#y = 1
			#return Vector2(sign(ball.position.x - position.x), y)
	#elif (ball != null and player == PlayerNumber.CPU3):
		#if not ball.in_play:
			#return Vector2(sign((ball.position.x+12) - position.x), sign((ball.position.y+12) - position.y))
		#else:
			#if abs(ball.position.y - position.y) > 50:
				#y = sign(ball.position.y - position.y)
			#elif ball.position.y > position.y: # position below the ball
				#y = 1
			#if abs(ball.position.x - position.x) < 20: # slow down
				#x = 0
			#else:
				#x = sign(ball.position.x - position.x)
			#return Vector2(x, y)
	#elif (ball != null and player == PlayerNumber.CPU4):
		#if not ball.in_play:
			#if cpu_next_position == Vector2.ZERO:
				#cpu_next_position = original_position
			#elif cpu_next_position == original_position:
				#if (position - cpu_next_position).length() > 10:
					#return Vector2(sign(cpu_next_position.x - position.x), sign(cpu_next_position.y - position.y))
				#else:
					#cpu_next_position = ball.position
			#elif cpu_next_position == ball.position:
				#return Vector2(sign((ball.position.x+12) - position.x), sign((ball.position.y+12) - position.y))
		#else:
			#if abs(ball.position.y - position.y) > 50:
				#y = sign(ball.position.y - position.y)
			#elif ball.position.y > position.y: # position below the ball
				#y = 1
			#if abs(ball.position.x - position.x) < 20: # slow down
				#x = 0
			#else:
				#x = sign(ball.position.x - position.x)
		#return Vector2(x, y)
	#else:
		#return Vector2.ZERO
			

func is_in_air() -> bool:
	return air_detector.get_overlapping_areas().size() > 0
		
