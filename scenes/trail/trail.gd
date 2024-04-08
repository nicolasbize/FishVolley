class_name Trail
extends Line2D

@export var max_length := 100

var queue:Array
var emitting := true
var target: Node2D = null

func clear():
	queue.clear()

func set_target(value:Node2D):
	target = value
	
func _process(delta):
	if emitting and target != null:
		var pos = target.global_position
		queue.push_front(pos)
		
	if queue.size() > max_length:
		queue.pop_back()

	clear_points()
	for point in queue:
		add_point(point)
