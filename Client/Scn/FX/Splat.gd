extends Particles2D


var life = lifetime

func _physics_process(delta):
	life -= delta
	if life <= 0:
		queue_free()


func _on_Timer_timeout():
	$Light.queue_free()
