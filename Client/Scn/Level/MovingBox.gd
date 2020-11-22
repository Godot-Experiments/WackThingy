extends StaticBody2D

export var extents:= 400
var dir := 1

func _physics_process(delta):
	if position.x >= extents or position.x <= 0:
		dir *= -1
	position.x += dir * 4
	position.x = clamp(position.x, 0, extents)
