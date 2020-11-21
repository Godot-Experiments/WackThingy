extends Node2D

onready var Player = load("res://Player.tscn")

func _ready():
	$Enemy.target = $FrenR
	$Spawn.player = $FrenR

puppet func spawn_player(spawn_pos, id):
	var player = Player.instance()
	
	player.position = spawn_pos
	player.name = String(id) # Important
	player.set_network_master(id) # Important
	
	$Players.add_child(player)


puppet func remove_player(id):
	$Players.get_node(String(id)).queue_free()


#func _on_Goal_body_entered(body):
#	if body == $Ball:
#		print("HIT!")
#		$Goal/Splat.emitting = true
