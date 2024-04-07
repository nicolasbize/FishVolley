class_name Splash
extends Node2D

enum SplashType {Small, Big}

@onready var particles := $GPUParticles2D

var being_destroyed = false
var type = SplashType.Small

func _ready():
	particles.emitting = true
	if type == SplashType.Big:
		particles.amount = 30
	else:
		particles.amount = 15

func _process(delta):
	if not being_destroyed and not particles.emitting:
		being_destroyed = true
		queue_free()
