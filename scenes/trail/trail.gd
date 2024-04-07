class_name Trail
extends Line2D

@export var max_length := 100
@export var fish:Fish

var queue:Array
var emitting := false
var time_since_last_clear := Time.get_ticks_msec()
var duration_between_clear := 50

func clear():
	queue.clear()

func _process(delta):
	if emitting:
		var pos = fish.global_position - Vector2.RIGHT.rotated(fish.rotation) * 10
		queue.push_front(pos)
	if queue.size() > 0 and (Time.get_ticks_msec() - time_since_last_clear > duration_between_clear):
		time_since_last_clear = Time.get_ticks_msec()
		queue.pop_back()

	clear_points()
	for point in queue:
		add_point(point)
