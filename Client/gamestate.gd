extends Node

# Game port and ip
var ip := ""
const DEFAULT_PORT = 42424
#const DEFAULT_PORT = 44444
# Signal to let GUI know whats up
signal connection_failed()
signal connection_succeeded()
signal server_disconnected()

var my_name = "Client"

# Players dict stored as id:name
var players = {}
var team: int = 0
var chara: int = 0

func _ready():
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	
	# Try to connect right away




func connect_to_server():
	var host = NetworkedMultiplayerENet.new()
	host.create_client(ip, DEFAULT_PORT)
	get_tree().set_network_peer(host)


# Callback from SceneTree, called when connect to server
func _connected_ok():
	emit_signal("connection_succeeded")


# Callback from SceneTree, called when server disconnect
func _server_disconnected():
	players.clear()
	get_node("/root/World").queue_free()
	get_node("/root/Main").show()
	emit_signal("server_disconnected")
	
	# Try to connect again
	connect_to_server()


# Callback from SceneTree, called when unabled to connect to server
func _connected_fail():
	get_tree().set_network_peer(null) # Remove peer
	emit_signal("connection_failed")
	
	# Try to connect again
	connect_to_server()


puppet func register_player(id, new_player_data, team: int, chara: int):
	players[id] = [new_player_data, team, chara]
	if id != get_tree().get_network_unique_id():
		other_players += [id]


puppet func unregister_player(id):
	players.erase(id)
	other_players.erase(id)


# Returns list of player names
func get_player_list():
	return players.values()


puppet func pre_start_game():
	# Register ourselves with the server
	rpc_id(1, "register_player", my_name, team, chara)
	
	# Load world
	get_node("/root/Main").hide()
	var world = load("res://World.tscn").instance()
	get_tree().get_root().add_child(world)
	
	# Tell Server we ready to roll
	rpc_id(1, "populate_world")


const DAMAGEABLE:= "0"
const HEADS := "1"
var colors: PoolColorArray = [Color("ff007e"), Color("007cff"), Color("af00ff"), Color("00ffdb"), Color("00ff16"), Color("85ff00"), Color("ffcb00"), Color("fe2b2b")]
var color_size = colors.size()
var light: int = 1
var laser_light: float = 0
var other_players: Array
