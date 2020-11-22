extends Area2D

const SPEED = 20
var vel: Vector2
#var possible: Array = [preload("res://Img/Laser/laser.png"), preload("res://Img/Laser/laser2.png"), preload("res://Img/Laser/laser3.png")]
export var dmg:= 1
var par
var team
const splat := preload("res://Scn/FX/Splat.tscn")
func _ready():
	randomize()
#	$Img.default_color = gamestate.colors[randi() % gamestate.color_size]
	$Img.default_color = gamestate.colors[team]
#	$laser.texture = possible[randi() % 3]

func _physics_process(_delta):
	position += vel

func _on_Laser_body_entered(body):
	if body.is_in_group(gamestate.DAMAGEABLE) and team != body.team:
		body.dmg(dmg)
		spawn_splat()
		queue_free()
	elif body is StaticBody2D:
		spawn_splat()
		queue_free()

func spawn_splat() -> void:
	var s = splat.instance()
	s.emitting = true
	s.global_position = $Img/Tip.global_position
	get_node("/root").add_child(s)


func setup(p: Vector2, v: Vector2, owner, t: int):
	global_position = p
	vel = v.normalized() * SPEED
	rotation = v.angle()
	par = owner
	team = t


func _on_Timer_timeout():
	spawn_splat()
	queue_free()
