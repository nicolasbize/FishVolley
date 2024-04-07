extends Node2D

signal ready_for_content

@onready var animation_player := $CanvasLayer/AnimationPlayer

func on_ready_for_content():
	emit_signal("ready_for_content")
	animation_player.play("finish")
	
func on_finish():
	queue_free()
