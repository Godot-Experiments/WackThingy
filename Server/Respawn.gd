extends Timer


var pid: int

func _on_Respawn_timeout():
	# possible race condition if new player joining (they need to retrieve player team)
	# just as this times out
	if pid in gamestate.players:
		var pos := gamestate.random_vector2(500, 0)
		match gamestate.players[pid][1]:
			1:
				pos += gamestate.enemy_offset
			2:
				pos += gamestate.enemy_offset / 2
				pos.y -= 3800
		get_parent().rpc("spawn_player", pos, pid)
		print("RESPAWNING")
	queue_free()

