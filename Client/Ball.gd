extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	bounce = .5

func _physics_process(delta):
	if linear_velocity.length() > 256 and $ball.animation == "default":
		$ball.set_animation("wink")
		$Splat.emitting = true
	else:
		$ball.set_animation("default")



