extends Node2D


var R := preload("res://Scn/FrenR/FrenRK.tscn")
var A := preload("res://Scn/OtherFrens/FrenA.tscn")
var Na := preload("res://Scn/OtherFrens/FrenNa.tscn")
var K := preload("res://Scn/OtherFrens/FrenK.tscn")
var N := preload("res://Scn/OtherFrens/FrenN.tscn")
var E := preload("res://Scn/OtherFrens/FrenE.tscn")

var S := preload("res://Scn/OtherFrens/FrenS.tscn")
var C := preload("res://Scn/OtherFrens/FrenC.tscn")
var chars := [R, A, Na, K, N, E, S, C]
#const Player := preload("res://Player.tscn")

puppet func spawn_player(spawn_pos, id):
	var pdata: Array = gamestate.players[id]
	var chara: int = pdata[2]
	var player
#	match chara:
#		0:
#			player = R.instance()
#		1:
#			player = A.instance()
#		2
#		6:
#			player = S.instance()
#		_:
#			player = R.instance()
	player = chars[chara].instance()
	player.position = spawn_pos
	player.name = String(id) # Important
	player.set_network_master(id) # Important

	player.setup(pdata[1], chara)
	if player.team == 1:
		player.flip_left(true)

	$Players.add_child(player)


puppet func remove_player(id):
	var p = $Players.get_node_or_null(String(id))
	if is_instance_valid(p):
		p.queue_free()


onready var dark: CanvasModulate = $Dark
var colors := [Color.black, Color("242424"), Color.white]

remote func d(c: int) -> void:
	# changes lighting
	$Tween.interpolate_property(dark, "color", dark.color, colors[c], 2)
	$Tween.start()
	gamestate.laser_light = min(.7/(c + .701), .6)
