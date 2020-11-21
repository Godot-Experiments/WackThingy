extends Control

onready var status = $Login/Panel/VBox/Status
onready var join_button = $Login/Panel/VBox/JoinButton
onready var name_edit = $Login/Panel/VBox/HBox/NameEdit
onready var panel = $Login/Panel

func _ready():
	gamestate.connect("connection_failed", self, "_on_connection_failed")
	gamestate.connect("connection_succeeded", self, "_on_connection_success")
	gamestate.connect("server_disconnected", self, "_on_server_disconnect")
	gamestate.connect("players_updated", self, "update_players_list")
	
	join_button.disabled = true
	
	status.text = "Connecting..."
	status.modulate = Color.yellow


func _on_JoinButton_pressed():
	gamestate.my_name = name_edit.text
	gamestate.pre_start_game()

func show() -> void:
	.show()
	panel.show()

func hide() -> void:
	.hide()
	panel.hide()

func _on_connection_success():
	join_button.disabled = false
	
	status.text = "Connected"
	status.modulate = Color.green


func _on_connection_failed():
	join_button.disabled = true
	
	status.text = "Connection Failed, trying again"
	status.modulate = Color.red


func _on_server_disconnect():
	join_button.disabled = true
	
	status.text = "Server Disconnected, trying to connect..."
	status.modulate = Color.red
