extends "res://Ball.gd"

var SPEED := 10
var vel : Vector2
var target = null
var ACC := .1
var TURN := .1
onready var world :Node2D = get_node_or_null("/root/world/objs")

remote func t(t_name: String = "") -> void:
	target = world.get_node_or_null(t_name)

func _ready():
	target = get_parent().get_node("FrenR")

func _physics_process(delta):
	move()

func move() -> void:
	if is_instance_valid(target):
		vel = Vector2(SPEED, 0).rotated((target.global_position - global_position).angle())

		apply_impulse(Vector2.ZERO, vel)
