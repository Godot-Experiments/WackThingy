extends Node2D

onready var Player = load("res://Player.tscn")
var color : int = 1

puppetsync func spawn_player(spawn_pos, id):
	var player = Player.instance()
	
	player.position = spawn_pos
	player.name = String(id) # Important
	player.set_network_master(id) # Important
	
	$Players.add_child(player)


puppetsync func remove_player(id):
	var p = $Players.get_node(String(id))
	if is_instance_valid(p):
		p.queue_free()


func _on_Timer_timeout():
	color = randi() % 3
	rpc("d", color)
