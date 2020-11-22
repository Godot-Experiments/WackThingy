extends Control

onready var status = $Login/Panel/VBox/Status
onready var join_button = $Login/Panel/VBox/JoinButton
onready var name_edit = $Login/Panel/VBox/VBoxContainer/HBox/NameEdit
onready var panel = $Login/Panel
onready var team = $Login/Panel/VBox/VBoxContainer/HBox2/Team
onready var chara = $Login/Panel/VBox/VBoxContainer/HBox3/CharSel

func _ready():
	gamestate.connect("connection_failed", self, "_on_connection_failed")
	gamestate.connect("connection_succeeded", self, "_on_connection_success")
	gamestate.connect("server_disconnected", self, "_on_server_disconnect")
#	gamestate.connect("players_updated", self, "update_players_list")
	
	join_button.disabled = true
	
	status.text = "Connecting..."
	status.modulate = Color.yellow
	team.add_item("Bully The SHek", 0)
	team.add_item("Save the sHEK", 1)
	_on_Team_item_selected(0)
	chara.add_item("Duhee", 0)
	chara.add_item("Shecc", 1)
	chara.add_item("Ban", 2)
	chara.add_item("Kreme", 3)
	chara.add_item("Fabulous", 4)
	chara.add_item("Me", 5)
	chara.add_item("Wich", 6)
	chara.add_item("Idoit", 7)
	_on_CharSel_item_selected(0)
	_on_Light_item_selected(1)



func _on_JoinButton_pressed():
	gamestate.my_name = name_edit.text
	gamestate.pre_start_game()
	$MenuCam.current = false

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


func _on_Team_item_selected(id: int):
	gamestate.team = id


func _on_CharSel_item_selected(id: int):
	gamestate.chara = id

func _on_Light_item_selected(id: int):
	gamestate.light = id
