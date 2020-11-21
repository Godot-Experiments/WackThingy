extends Position2D

export var extent := 700
var player

func _physics_process(delta):
	if is_instance_valid(player) and player.position.y > extent:
		player.position = position
