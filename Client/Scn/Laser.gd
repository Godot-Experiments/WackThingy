extends Area2D

const SPEED = 20
var vel: Vector2
#var possible: Array = [preload("res://Img/Laser/laser.png"), preload("res://Img/Laser/laser2.png"), preload("res://Img/Laser/laser3.png")]
export var dmg := 1
var par
var team
var hp := 1
const splat := preload("res://Scn/FX/Splat.tscn")
func _ready():
	$Light.energy = gamestate.laser_light
	if team == 2:
		randomize()
		$Img.default_color = gamestate.colors[randi() % gamestate.color_size]
	else:
		$Img.default_color = gamestate.colors[team]
#	$laser.texture = possible[randi() % 3]

func _physics_process(_delta):
	position += vel

func _on_Laser_body_entered(body):
	if hp >= 1 and body.is_in_group(gamestate.DAMAGEABLE) and (team != body.team or team == 2):
		body.dmg(dmg)
		hp -= 1
		spawn_splat()
		queue_free()
	elif body is StaticBody2D:
		spawn_splat()
		queue_free()


func spawn_splat(modif: int = 1) -> void:
	var s: Particles2D = splat.instance()
	s.emitting = true
	s.amount *= modif
	s.scale += Vector2(modif / 4, modif / 4)
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


func _on_Laser_area_entered(area):
	if hp >= 1 and area.is_in_group(gamestate.HEADS) and (team != area.team or team == 2):
		area.dmg(dmg * 2)
		hp -= 1
		spawn_splat(2)
		queue_free()
