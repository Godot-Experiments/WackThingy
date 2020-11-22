extends Timer


var pid: int

func _on_Respawn_timeout():
	var pos := gamestate.random_vector2(500, 500)
	if gamestate.players[pid][1] == 1:
		pos += Vector2(500, 0)
	get_parent().rpc("spawn_player", pos, pid)

