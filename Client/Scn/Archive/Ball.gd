extends RigidBody2D


func _ready():
	bounce = .5
	
func _physics_process(delta):
	if linear_velocity.length() > 256 and $ball.animation == "default":
		$ball.set_animation("wink")
		$Splat.emitting = true
	else:
		$ball.set_animation("default")



