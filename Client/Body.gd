extends RigidBody2D

var vel := Vector2.ZERO
const SPEED = 25
const JUMP := 100
puppet var p: Vector2 = Vector2.ZERO

#func _integrate_forces(state: Physics2DDirectBodyState):
#	var form := state.get_transform()
#	if is_network_master():
#		print("SDLFJ")
#		rset("p", form.origin)
#	elif $Timer.is_stopped():
#		form.origin.x = p.x
#		form.origin.y = p.y
#		state.set_transform(form)
#		$Timer.start()

remote func u(v: Vector2) -> void:
	vel = v

remote func j() -> void:
	apply_impulse(Vector2.ZERO, Vector2(0, -JUMP))

func _process(delta):
	if is_network_master() and (Input.is_action_just_pressed("ui_right")
			or Input.is_action_just_pressed("ui_left") 
			or Input.is_action_just_released("ui_left") 
			or Input.is_action_just_released("ui_right") 
			):
		var magnitude : float = SPEED * (Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"))
		vel = Vector2(magnitude, 0)
		rpc("u", vel)
	if is_network_master() and Input.is_action_just_pressed("ui_up"):
#		var magnitude : float = SPEED * (Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"))
		j()
		rpc("j")
		

#		rset_unreliable("puppet_pos", position)
#		rset_unreliable("puppet_vel", velocity)
#	else:
#		# If we are not the ones controlling this player, 
#		# sync to last known position and velocity
#		position = puppet_pos
#		velocity = puppet_vel
#
#	position += velocity * delta
#
#	if not is_network_master():
#		# It may happen that many frames pass before the controlling player sends
#		# their position again. If we don't update puppet_pos to position after moving,
#		# we will keep jumping back until controlling player sends next position update.
#		# Therefore, we update puppet_pos to minimize jitter problems
#		puppet_pos = position

func _physics_process(delta):
#	if is_network_master():
	apply_impulse(Vector2.ZERO, vel)
