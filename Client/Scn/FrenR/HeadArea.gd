extends Area2D


func dmg(d: int):
	get_parent().dmg(d)
	print(d)

func _ready():
	add_to_group(gamestate.HEADS)
