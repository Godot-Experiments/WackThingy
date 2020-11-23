extends Node2D

var vel : Vector2
var rot : float

var txts := ["OoF", "Ow", "Bruh", "I huRt", "WhY"]
var txts_size := txts.size()
onready var text_label = $Txt

func _ready():
	randomize()
	rotation = (randf() - .5) * 12
	vel = Vector2(randf() - .5, randf() - .5) * 32
	rot = (randf() - .5) / 2
	text_label.text = txts[randi() % txts_size]

func _physics_process(delta):
	position += vel
	vel = vel.linear_interpolate(Vector2.ZERO, .05)
	rotation += rot
	rot = lerp_angle(rot, 0, .05)


func _on_Timer_timeout():
	$Anim.play("Fade")



func _on_Anim_animation_finished(anim_name):
	queue_free()
