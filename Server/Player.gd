extends Node2D


remote func w(wa: int):
	pass

remote func jump() -> void:
	pass

remote func ur(rot: float) -> void:
	pass

remote func die():
	queue_free()

remote func p(pos: Vector2) -> void:
	position = pos
