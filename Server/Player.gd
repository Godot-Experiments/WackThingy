extends Node2D


remote func w(wa: int):
	pass

remote func jump() -> void:
	pass

remote func ur(rot: float) -> void:
	pass

const respawn := preload("res://Respawn.tscn")
remote func die():
	var r = respawn.instance()
	r.pid = get_network_master()
	get_node("/root/World").add_child(r)
	queue_free()

remote func p(pos: Vector2) -> void:
	position = pos
