class_name Fish
extends CharacterBody2D

const Splash := preload("res://scenes/splash/splash.tscn")
const Trail := preload("res://scenes/trail/trail.tscn")

enum ControlScheme {PlayerOne, PlayerTwo, CPU}

enum CpuState {Idle, GoToDestination, TurnTowardsBall, GoTowardsBall}

@export var rotation_speed := 15.0
@export var air_rotation_speed := 5.0
@export var control : ControlScheme = ControlScheme.PlayerOne
@export var max_speed := 700.0
@export var acceleration := 400.0
@export var friction := 200.0
@export var gravity := Vector2.DOWN * 200.0

@onready var air_detector := $AirDetector
@onready var water_detector := $WaterDetector
@onready var bubbles := $BubblesParticles
@onready var trail := $TrailParticles
@onready var animation_player := $AnimationPlayer

var target_angle := 0.0
var ball : Ball
var reset_position := Vector2(240, 240)
var cpu_state := CpuState.Idle
var cpu_destination := Vector2.ZERO
var was_high_in_air := false
var was_in_air := false
var cpu_difficulty := 0

func _init():
	if not GameState.is_connected("point_started", on_point_started.bind()):
		GameState.connect("point_started", on_point_started.bind())
	if not GameState.is_connected("point_stopped", on_point_stopped.bind()):
		GameState.connect("point_stopped", on_point_stopped.bind())

func on_point_started(target:Ball):
	ball = target
	cpu_state = CpuState.Idle

func on_point_stopped():
	ball = null
	cpu_state = CpuState.Idle

func _physics_process(delta):
	var in_air = is_in_air()
	var input_vector := get_input_vector(delta)
	if in_air:
		velocity += gravity * delta
		rotation += input_vector.x * delta * air_rotation_speed
		if position.y < 150:
			was_high_in_air = true
		if input_vector.y < 0:
			velocity += Vector2.RIGHT.rotated(rotation) * delta * 50.0
		bubbles.emitting = false
		trail.emitting = true
		if !was_in_air and velocity.length() > 120:
			create_splash(0)
	else:
		bubbles.emitting = true
		trail.emitting = false
		if input_vector != Vector2.ZERO:
			target_angle = input_vector.angle()
			rotation = rotate_toward(rotation, target_angle, delta * rotation_speed)
			#rotation += input_vector.x * delta * air_rotation_speed
			var target_velocity = Vector2.RIGHT.rotated(rotation) * max_speed
			velocity = velocity.move_toward(target_velocity, delta * acceleration)
		else:
			# water friction when not moving
			velocity = velocity.move_toward(Vector2.RIGHT.rotated(rotation) * 2.0, delta * friction)
		if was_high_in_air:
			GameSounds.play(GameSounds.Sound.Splash)
			create_splash(1)
			was_high_in_air = false
	was_in_air = in_air
	
	if velocity.length() < 80 and not in_air:
		animation_player.play("idle")
	else:
		animation_player.play("swim")
	
	move_and_slide()
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is Ball:
			var target : Ball = c.get_collider()
			target.start_motion()
			target.linear_velocity = Vector2.ZERO
			target.apply_central_impulse(-c.get_normal() * max(120.0 + velocity.length() / 2.0, ball.linear_velocity.length()))
			GameSounds.play(GameSounds.Sound.Hit, true)
	
func get_input_vector(delta) -> Vector2:
	if control == ControlScheme.PlayerOne:
		return Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down"))
	elif control == ControlScheme.PlayerTwo:
		return Vector2(Input.get_axis("move_left_2", "move_right_2"), Input.get_axis("move_up_2", "move_down_2")) 
	else:
		if ball != null:
			return get_cpu_input_vector(delta)
	return Vector2.ZERO

func get_cpu_input_vector(delta) -> Vector2:
	if cpu_difficulty == 0:
		return get_cpu_0_input_vector(delta)
	elif cpu_difficulty == 1:
		return get_cpu_1_input_vector(delta)
	elif cpu_difficulty == 2:
		return get_cpu_2_input_vector(delta)
	else:
		return get_cpu_3_input_vector(delta)

func get_cpu_0_input_vector(delta) -> Vector2:
	return Vector2(sign(ball.position.x - position.x), sign(ball.position.y - position.y))
	
func get_cpu_1_input_vector(delta) -> Vector2:
	var x := 0.0
	var y := 0.0
	if not ball.in_play:
		return Vector2(sign(ball.position.x - position.x), sign(ball.position.y - position.y))
	else:
		if ball.position.y > position.y: # position below the ball
			y = 1
		return Vector2(sign(ball.position.x - position.x), y)
		
func get_cpu_2_input_vector(delta) -> Vector2:
	var x := 0.0
	var y := 0.0
	if not ball.in_play:
		return Vector2(sign((ball.position.x+12) - position.x), sign((ball.position.y+12) - position.y))
	else:
		if abs(ball.position.y - position.y) > 50:
			y = sign(ball.position.y - position.y)
		elif ball.position.y > position.y: # position below the ball
			y = 1
		if abs(ball.position.x - position.x) < 20: # slow down
			x = 0
		else:
			x = sign(ball.position.x - position.x)
		return Vector2(x, y)
	

func get_cpu_3_input_vector(delta) -> Vector2:
	var x := 0.0
	var y := 0.0
	if not ball.in_play:
		if cpu_state == CpuState.Idle:
			cpu_state = CpuState.GoToDestination
			cpu_destination = reset_position
		elif cpu_state == CpuState.GoToDestination:
			if (position - cpu_destination).length() > 10:
				return Vector2(sign(cpu_destination.x - position.x), sign(cpu_destination.y - position.y))
			else:
				if cpu_destination == reset_position:
					cpu_state = CpuState.TurnTowardsBall
		elif cpu_state == CpuState.TurnTowardsBall:
			print("diff" + str((ball.position - position).angle() - rotation))
			if abs((ball.position - position).angle() - rotation) > 0.1:
				rotation += delta * rotation_speed
			else:
				cpu_state = CpuState.GoTowardsBall
		elif cpu_state == CpuState.GoTowardsBall:
			return Vector2(sign((ball.position.x+12) - position.x), sign((ball.position.y+12) - position.y))
	else:
		if abs(ball.position.y - position.y) > 50:
			y = sign(ball.position.y - position.y)
		elif ball.position.y > position.y: # position below the ball
			y = 1
		if abs(ball.position.x - position.x) < 20: # slow down
			x = 0
		else:
			x = sign(ball.position.x - position.x)
	return Vector2(x, y)
			
func is_in_air() -> bool:
	return air_detector.get_overlapping_areas().size() > 0
		
func create_splash(splash_type: Splash.SplashType) -> void:
	var splash = Splash.instantiate()
	splash.type = splash_type
	get_parent().add_child(splash)
	splash.global_position = global_position + Vector2.RIGHT.rotated(rotation) * 10
