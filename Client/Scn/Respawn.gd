extends Timer


onready var time = $CanvasLayer/Time

func _physics_process(delta):
	time.text = str(stepify(time_left, .1))

func _on_Respawn_timeout():
	get_parent().queue_free()
