extends Area2D

var team: int
func dmg(d: int):
	get_parent().dmg(d)


func _ready():
	add_to_group(gamestate.HEADS)
	team = get_parent().team
