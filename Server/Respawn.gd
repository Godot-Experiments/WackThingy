extends Timer


var pid: int

func _on_Respawn_timeout():
	# possible race condition if new player joining (they need to retrieve player team)
	# just as this times out
	if pid in gamestate.players:
		var pos := gamestate.random_vector2(500, 500)
		if gamestate.players[pid][1] == 1:
			pos += Vector2(500, 0)
		get_parent().rpc("spawn_player", pos, pid)
		print("RESPAWNING")

