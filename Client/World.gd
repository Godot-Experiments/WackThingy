extends Node2D


var Player = preload("res://Scn/FrenR/FrenRK.tscn")
#const Player = preload("res://Player.tscn")

puppet func spawn_player(spawn_pos, id):
	var player = Player.instance()
	
	player.position = spawn_pos
	player.name = String(id) # Important
	player.set_network_master(id) # Important
	var pdata: Array = gamestate.players[id]
	player.setup(pdata[1], pdata[2])
	if player.team == 1:
		player.flip_left(true)

	$Players.add_child(player)


puppet func remove_player(id):
	var p = $Players.get_node_or_null(String(id))
	if is_instance_valid(p):
		p.queue_free()


onready var dark: CanvasModulate = $Dark
var colors := [Color("242424"), Color.white, Color.black]

remote func d(c: int) -> void:
	# changes lighting
	print(c)
	$Tween.interpolate_property(dark, "color", dark.color, colors[c], 2)
	$Tween.start()
