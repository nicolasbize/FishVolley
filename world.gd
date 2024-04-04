extends Node2D

var score := Vector2(0, 0)

@export var ball : Ball
@export var kickoff1 : Node2D
@export var kickoff2 : Node2D

@onready var score_control := $UI/ScoreControl
@onready var score_label := $UI/ScoreControl/ScoreLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	ball.connect("play_started", on_play_started.bind())
	start_round()


func start_round():
	if score == Vector2.ZERO:
		var kickoff_positions = [kickoff1, kickoff2]
		kickoff_positions.shuffle()
		ball.position = kickoff_positions[0].position
		ball.reset()
		update_score()
		score_control.visible = true

func on_play_started():
	score_control.visible = false

func update_score():
	score_label.text = str(score.x) + " - " + str(score.y)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
