extends Node2D



func _on_Goal_body_entered(body):
	if body == $Ball:
		print("HIT!")
		$Goal/Splat.emitting = true
